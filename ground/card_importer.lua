-- Runtime batch importer. Shared helpers and JSON data are prepended by the build tool.
-- A line is: exact card number, one space, positive integer quantity.
-- UI locale affects presentation only; source identity, tags and stats stay unchanged.
local API_ROOT = "https://llofficial-cardgame.com/manage/card-list-user/"
-- The official host returns 404 to UnityPlayer clients. Verified in the running TTS engine.
-- WebRequest.custom allows us to provide an accepted User-Agent for these JSON requests.
local API_HEADERS = {
    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/130.0.0.0 Safari/537.36",
    ["Accept"] = "application/json",
    ["Referer"] = "https://llofficial-cardgame.com/cardlist/"
}
local MAX_CARDS = 200 -- Import size guard, not a deck-building legality rule.
local MAX_TYPES = 60
local IMPORT_ORIGIN = {x = 0, y = 3, z = 12}
local DEFAULT_LIST = "PL!-bp3-021-SRL 2\nPL!-pb2-000-R 4\nPL!S-PR-034-PR+ 6"
local importText = DEFAULT_LIST
local batchSequence = 0
local running = false
local sourceCache = {}
local activeJob = nil
local importStatusText = nil
local SERIES = {
    ["μ's"] = "ラブライブ！", ["Aqours"] = "ラブライブ！サンシャイン!!",
    ["虹ヶ咲"] = "ラブライブ！虹ヶ咲学園スクールアイドル同好会",
    ["Liella!"] = "ラブライブ！スーパースター!!",
    ["蓮ノ空"] = "ラブライブ！蓮ノ空女学院スクールアイドルクラブ",
    ["IKZ"] = "イキヅライブ！ LOVELIVE! BLUEBIRD"
}

local function normalizeNumber(number)
    return normalizeCardNumber(number)
end

local function trim(text)
    return (string.gsub(string.gsub(text, "^%s+", ""), "%s+$", ""))
end

local function status(text)
    importStatusText = text
    UI.setAttribute("lc_import_status", "text", text)
    print("[LoveCa] " .. text)
end

local function finishJob(message)
    -- Failed or timed-out imports must not leave suspended cards locked in place.
    if activeJob then
        for _, entry in ipairs(activeJob.objects) do
            if entry.timer then Wait.stop(entry.timer) end
            if entry.object and not entry.object.isDestroyed() then entry.object.setLock(false) end
        end
    end
    activeJob = nil
    running = false
    UI.setAttribute("lc_import_button", "interactable", "true")
    status(message)
end

local function parseList(text)
    local entries, byNumber, total, lineNumber = {}, {}, 0, 0
    text = normalizeCardNumber(text)
    text = string.gsub(text, "\r", "")
    for line in string.gmatch(text .. "\n", "(.-)\n") do
        lineNumber = lineNumber + 1
        line = trim(line)
        if line ~= "" and string.sub(line, 1, 1) ~= "#" then
            local number, countText = string.match(line, "^(%S+)%s+(%d+)$")
            local count = tonumber(countText)
            if not number or not count or count < 1 or count > MAX_CARDS then
                error(tr("行 ") .. lineNumber .. tr("：カード番号と 1～") .. MAX_CARDS .. tr(" の枚数を入力してください。"))
            end
            if not string.match(number, "^[%w!%+%-]+$")
                and not string.match(normalizeNumber(number), "^[%w!%+%-]+$") then
                error(tr("行 ") .. lineNumber .. tr("：カード番号の形式が正しくありません。"))
            end
            local key = normalizeNumber(number)
            if not byNumber[key] then
                byNumber[key] = {number = number, count = 0}
                table.insert(entries, byNumber[key])
            end
            byNumber[key].count = byNumber[key].count + count
            total = total + count
            if total > MAX_CARDS then error(tr("一度のインポートは ") .. MAX_CARDS .. tr(" 枚までです。")) end
            if #entries > MAX_TYPES then error(tr("一度のインポートは ") .. MAX_TYPES .. tr(" 種類までです。")) end
        end
    end
    if total == 0 then error(tr("カードリストが空です。")) end
    return entries, total
end

local function requestJSON(url, callback)
    local completed, request, timer = false, nil, nil
    local function complete(data, message)
        if completed then return end
        completed = true
        if timer then Wait.stop(timer) end
        callback(data, message)
    end
    request = WebRequest.custom(url, "GET", true, "", API_HEADERS, function(response)
        local contentType = response.getResponseHeader("Content-Type") or ""
        if response.is_error or response.response_code ~= 200 then
            print("[LoveCa HTTP] GET " .. url .. " / status=" .. tostring(response.response_code)
                .. " / Content-Type=" .. contentType .. " / error=" .. tostring(response.error or ""))
            complete(nil, tr("通信エラー（HTTP ") .. tostring(response.response_code) .. "）："
                .. tostring(response.error or "") .. " / URL: " .. url)
            return
        end
        if not string.find(string.lower(contentType), "application/json", 1, true) then
            complete(nil, tr("カード API が JSON を返しませんでした（") .. contentType .. "） / URL: " .. url)
            return
        end
        local ok, data = pcall(JSON.decode, response.text)
        if not ok or type(data) ~= "table" then
            complete(nil, tr("カード API が有効な JSON を返しませんでした / URL: ") .. url)
            return
        end
        -- TTS JSON.decode expands \u escapes into UTF-8 byte strings, while script/UI
        -- literals are native Unicode. Normalize names, types, icons and keys together.
        local normalized, nativeData = pcall(nativeJSONText, data)
        if not normalized then
            complete(nil, tr("カード API の文字コードを変換できませんでした / URL: ") .. url)
            return
        end
        complete(nativeData)
    end)
    timer = Wait.time(function()
        if completed then return end
        if request then request.dispose() end
        complete(nil, tr("カード API の応答がタイムアウトしました / URL: ") .. url)
    end, 25)
end

local function utf8Character(code)
    return unicodeCharacter(code)
end

local function decodeHTML(text)
    local entities = {amp = "&", lt = "<", gt = ">", quot = '"', apos = "'", nbsp = " "}
    return (string.gsub(text, "&([^;]+);", function(entity)
        local hex = string.match(entity, "^#[xX]([%da-fA-F]+)$")
        local decimal = string.match(entity, "^#(%d+)$")
        local code = hex and tonumber(hex, 16) or (decimal and tonumber(decimal))
        return code and utf8Character(code) or entities[entity] or ("&" .. entity .. ";")
    end))
end

local function abilityFrom(raw)
    if not raw.text_html or raw.text_html == "" then
        return raw.text and raw.text ~= "-" and raw.text or ""
    end
    local text = string.gsub(raw.text_html, "<[iI][mM][gG]%s[^>]*>", function(tag)
        local src = string.match(tag, 'src%s*=%s*"([^"]+)"') or string.match(tag, "src%s*=%s*'([^']+)'")
        local alt = string.match(tag, 'alt%s*=%s*"([^"]*)"') or string.match(tag, "alt%s*=%s*'([^']*)'") or ""
        if not src then error(tr("技能アイコンに画像パスがありません。")) end
        return "{{" .. (string.match(src, "([^/]+)$") or src) .. "|" .. alt .. "}}"
    end)
    text = string.gsub(text, "<[bB][rR]%s*/?>", "\n")
    text = string.gsub(text, "<[^>]+>", "")
    text = trim(decodeHTML(text))
    -- Some official records escape their line-break markup (e.g. Eutopia).
    -- Decode it as a line break too, without changing any source wording.
    text = string.gsub(text, "<[bB][rR]%s*/?>[ \t]*\r?\n?", "\n")
    return text ~= "-" and text or ""
end

local function numericField(raw, field, absentValue)
    if absentValue ~= nil and (raw[field] == nil or raw[field] == "" or raw[field] == "-") then
        return absentValue
    end
    local value = tonumber(raw[field])
    if not value or value < 0 or value ~= math.floor(value) then
        error(tr("数値フィールドが不正です：") .. field)
    end
    return value
end

local function cheerHearts(text)
    local result = {}
    local colors = {{"桃", "01"}, {"赤", "02"}, {"黄", "03"},
        {"緑", "04"}, {"青", "05"}, {"紫", "06"}, {"無", "07"}, {"ALL", "all"}}
    for _, color in ipairs(colors) do
        for count in string.gmatch(text or "", color[1] .. "(%d+)") do
            local key = color[2] == "all" and "b_all" or ("b_heart" .. color[2])
            result[key] = (result[key] or 0) + tonumber(count)
        end
    end
    return result
end

local function convertOfficial(data, requested, detailURL)
    local raw = data.card
    if type(raw) ~= "table" or not raw.card_number or not raw.picture then
        error(tr("カードの詳細データが不足しています。"))
    end
    if normalizeNumber(raw.card_number) ~= normalizeNumber(requested) then
        error(tr("検索結果と詳細のカード番号が一致しません。"))
    end
    if raw.card_kind ~= "ライブ" and raw.card_kind ~= "メンバー" and raw.card_kind ~= "エネルギー" then
        error(tr("未対応のカード種類です：") .. tostring(raw.card_kind))
    end
    if string.sub(raw.picture, 1, 1) == "/" or string.find(raw.picture, "..", 1, true)
        or string.find(raw.picture, "\\", 1, true) then error(tr("カード画像パスが不正です。")) end
    local products = {}
    for _, product in ipairs(data.expansions or {}) do
        if product.name and product.name ~= "" then table.insert(products, product.name) end
    end
    local card = {card_no = raw.card_number, name = raw.card_name or "", rare = raw.rare,
        type = raw.card_kind, product = table.concat(products, " / "),
        img = "https://llofficial-cardgame.com/wordpress/wp-content/images/cardlist/" .. raw.picture,
        _img = "img/cards/" .. raw.picture, ability = abilityFrom(raw),
        faq = copy(data.faqs or {}), rare_list = copy(data.relationCards or {}),
        source = {url = detailURL, kind = "official_api"}, official = copy(raw)}
    local titles = {}
    for title in string.gmatch(raw.work_title or "", "[^/]+") do
        title = trim(title)
        if title ~= "" and title ~= "-" then table.insert(titles, SERIES[title] or title) end
    end
    card.series = table.concat(titles, "\n")
    if raw.unit_name and raw.unit_name ~= "-" then card.unit = raw.unit_name end
    local hearts = {}
    for index = 0, 6 do
        local key = index == 0 and "heart0" or string.format("heart%02d", index)
        local value = (raw[key] == nil or raw[key] == "") and 0 or numericField(raw, key)
        if value ~= 0 then hearts[key] = value end
    end
    if card.type == "メンバー" then
        card.cost = numericField(raw, "cost")
        -- The official API uses '-' for members with no printed Blade icons (verified on card 30).
        card.blade = numericField(raw, (raw.blade and raw.blade ~= "" and raw.blade ~= "-") and "blade" or "attack", 0)
        card.base_heart = hearts
        card.blade_heart = cheerHearts(raw.blade_heart)
    elseif card.type == "ライブ" then
        card.score = numericField(raw, "blade_heart")
        card.need_heart = hearts
        card.blade_heart = cheerHearts(raw.blade or raw.attack)
        card.special_heart = {}
        for _, item in ipairs({{"スコア", "score"}, {"ドロー", "draw"}}) do
            for count in string.gmatch(raw.cost or "", item[1] .. "(%d*)") do
                card.special_heart[item[2]] = (card.special_heart[item[2]] or 0) + (tonumber(count) or 1)
            end
        end
    end
    baseCardNumber(card) -- Reject malformed rarity suffixes before creating any objects.
    return card
end

local function fetchSource(number, callback)
    local key = normalizeNumber(number)
    if sourceCache[key] then callback(sourceCache[key]); return end
    -- Search by base number, then require the exact variant locally. This also supports
    -- ASCII '+' input when the official card number contains the full-width '＋'.
    local searchNumber = string.match(number, "^(.*)%-[^%-]+$") or number
    local url = API_ROOT .. "list?keyword=" .. escapeURL(searchNumber)
        .. "&keyword_type=no&page=1&per_page=100&sort=no"
    requestJSON(url, function(data, message)
        if not data then callback(nil, message); return end
        local selected = nil
        for _, item in ipairs(data.items or {}) do
            if item.card_number and normalizeNumber(item.card_number) == key then selected = item; break end
        end
        if not selected or not selected.id then callback(nil, tr("該当するカード番号がありません：") .. number); return end
        local detailURL = API_ROOT .. "detail?id=" .. escapeURL(tostring(selected.id))
        requestJSON(detailURL, function(detail, detailError)
            if not detail then callback(nil, detailError); return end
            local ok, card = pcall(convertOfficial, detail, number, detailURL)
            if not ok then callback(nil, tostring(card)); return end
            sourceCache[key] = card
            callback(card)
        end)
    end)
end

local function recoveredSequence()
    local largest = batchSequence
    local function inspect(data)
        if data.Memo and data.Memo ~= "" then
            local ok, memo = pcall(decodeJSON, data.Memo)
            if ok and type(memo) == "table" and memo.schema == "loveca.card" and memo.import then
                largest = math.max(largest, tonumber(memo.import.sequence) or 0)
            end
        end
        for _, child in ipairs(data.ContainedObjects or {}) do inspect(child) end
    end
    for _, object in ipairs(getObjects()) do inspect(object.getData()) end
    return largest
end

local function importPositions(count)
    local positions = {}
    local occupied = {}
    for _, object in ipairs(getObjects()) do
        if object.type == "Card" or object.type == "Deck" then
            table.insert(occupied, object.getPosition())
        end
    end
    -- Keep new batches away from old cards/decks, which could otherwise merge on landing.
    for _, offset in ipairs({{-4, -8}, {4, -8}, {-4, -16}, {4, -16},
        {-4, 0}, {4, 0}, {-4, -24}, {4, -24}}) do
        local position = {x = IMPORT_ORIGIN.x + offset[1], y = IMPORT_ORIGIN.y,
            z = IMPORT_ORIGIN.z + offset[2]}
        local free = true
        for _, existing in ipairs(occupied) do
            if math.abs(existing.x - position.x) < 4.5 and math.abs(existing.z - position.z) < 6 then
                free = false
                break
            end
        end
        if free then
            table.insert(positions, position)
            if #positions == count then return positions end
        end
    end
    error(tr("インポート用の空きスペースがありません。中央のカードを移動してから再実行してください。"))
end

local function buildImportObjects(job)
    local groups = {main = {cards = {}, definitions = {}, ids = {}},
        energy = {cards = {}, definitions = {}, ids = {}}}
    local definitionIDs, nextDefinition = {}, 0
    local reservedGUIDs = {}
    local function reserveExisting(data)
        if data.GUID and data.GUID ~= "" then reservedGUIDs[data.GUID] = true end
        for _, child in ipairs(data.ContainedObjects or {}) do reserveExisting(child) end
    end
    for _, object in ipairs(getObjects()) do reserveExisting(object.getData()) end
    local function cardGUID()
        local guid
        repeat guid = string.format("%06x", math.random(0, 0xFFFFFF)) until not reservedGUIDs[guid]
        reservedGUIDs[guid] = true
        return guid
    end
    job.expected = {}
    for index, entry in ipairs(job.copies) do
        local sourceKey = normalizeNumber(entry.source.card_no)
        if not definitionIDs[sourceKey] then
            nextDefinition = nextDefinition + 1
            definitionIDs[sourceKey] = nextDefinition
        end
        local card = buildCardData(entry.source)
        card.import = {batch_id = job.id, sequence = batchSequence, copy_index = index,
            requested_count = entry.count, pile = entry.pile}
        card.instance_id = job.id .. "." .. index
        job.expected[card.instance_id] = {card_no = sourceKey, pile = entry.pile, index = index}
        local definitionID = definitionIDs[sourceKey]
        local data = cardObjectData(card, definitionID)
        data.GUID = cardGUID() -- Contained cards need their own GUID before the deck is created.
        local groupData = groups[entry.pile]
        table.insert(groupData.cards, data)
        table.insert(groupData.ids, data.CardID)
        groupData.definitions[tostring(definitionID)] = data.CustomDeck[tostring(definitionID)]
    end
    local plans = {}
    for _, pile in ipairs({"main", "energy"}) do
        local groupData = groups[pile]
        local count = #groupData.cards
        if count > 0 then
            local data
            if count == 1 then
                data = groupData.cards[1]
            else
                data = {
                    Name = "DeckCustom", DeckIDs = groupData.ids,
                    ContainedObjects = groupData.cards, CustomDeck = groupData.definitions,
                    Transform = {posX = 0, posY = 0, posZ = 0, rotX = 0, rotY = 180, rotZ = 0,
                        scaleX = CARD_SCALE[1], scaleY = CARD_SCALE[2], scaleZ = CARD_SCALE[3]},
                    Nickname = pile == "main" and tr("メインデッキ") or tr("エネルギーデッキ"),
                    Description = tr("インポート ") .. job.id .. " / " .. count .. tr(" 枚"),
                    Memo = encodeJSON({schema = "loveca.deck", schema_version = 1,
                        batch_id = job.id, sequence = batchSequence, pile = pile, count = count}),
                    ColorDiffuse = {r = 0.713235259, g = 0.713235259, b = 0.713235259, a = 1},
                    SidewaysCard = false, Grid = true, Snap = true, Sticky = true,
                    Tooltip = true, Hands = true, HideWhenFaceDown = true,
                    DragSelectable = true, LuaScript = "", LuaScriptState = "", XmlUI = ""
                }
            end
            data.Locked = true
            table.insert(plans, {data = data, pile = pile, count = count})
        end
    end
    local positions = importPositions(#plans)
    for index, plan in ipairs(plans) do
        plan.position = positions[index]
        plan.data.Transform.posX = plan.position.x
        plan.data.Transform.posY = plan.position.y + 6
        plan.data.Transform.posZ = plan.position.z
    end
    return plans
end

local function auditImport(job)
    local seen, guids, count, piles = {}, {}, 0, {main = 0, energy = 0}
    local function inspect(data, pile)
        if data.Name == "CardCustom" or data.Name == "Card" then
            local ok, card = pcall(decodeJSON, data.Memo or "")
            if not ok or type(card) ~= "table" or card.schema ~= "loveca.card" then
                error(tr("カードのメタデータが不足しています。"))
            end
            -- Scan the whole current batch, including any extra objects outside the planned roots.
            if not card.import or card.import.batch_id ~= job.id then return end
            local expected = job.expected[card.instance_id]
            if not expected or seen[card.instance_id] then
                error(tr("カードの個体番号が重複、または予定外です：") .. tostring(card.instance_id))
            end
            pile = pile or card.import.pile
            if card.import.pile ~= pile or expected.pile ~= pile or normalizeNumber(card.card_no) ~= expected.card_no
                or card.import.copy_index ~= expected.index then error(tr("生成したカードがリストと一致しません。")) end
            if not data.GUID or data.GUID == "" then error(tr("カード GUID がありません。")) end
            if guids[data.GUID] then error(tr("カード GUID が重複しています。")) end
            guids[data.GUID] = true
            seen[card.instance_id] = true
            count = count + 1
            piles[pile] = piles[pile] + 1
        end
        if data.Memo and data.Name == "DeckCustom" then
            local ok, memo = pcall(decodeJSON, data.Memo)
            if ok and type(memo) == "table" and memo.schema == "loveca.deck" and memo.batch_id == job.id then
                pile = memo.pile
            end
        end
        for _, child in ipairs(data.ContainedObjects or {}) do inspect(child, pile) end
    end
    for _, root in ipairs(job.objects) do
        local quantity = root.object.type == "Deck" and root.object.getQuantity() or 1
        if quantity ~= root.count then error(tr("牌組の枚数が一致しません：予定 ") .. root.count .. tr(" / 実際 ") .. quantity) end
    end
    for _, object in ipairs(getObjects()) do inspect(object.getData()) end
    if count ~= job.total then
        error(tr("生成枚数が一致しません：予定 ") .. job.total .. tr(" / 実際 ") .. count)
    end
    for instance in pairs(job.expected) do
        if not seen[instance] then error(tr("予定したカードがありません：") .. instance) end
    end
    return piles
end

local function completeSpawn(job)
    if job.finishing then return end
    job.finishing = true
    status(tr("画像と生成枚数を確認しています：") .. job.total .. tr(" 枚"))
    Wait.condition(function()
        if activeJob ~= job then return end
        local ok, piles = pcall(auditImport, job)
        if not ok then
            finishJob(tr("生成結果の確認に失敗：") .. tostring(piles) .. tr("。生成物を確認してください。"))
            return
        end
        for _, root in ipairs(job.objects) do
            root.object.setPosition({root.position.x, root.position.y, root.position.z})
        end
        finishJob(tr("インポート完了：メイン ") .. piles.main .. tr(" / エネルギー ") .. piles.energy
            .. tr(" / 合計 ") .. job.total .. tr(" 枚 / ポイント ") .. job.points
            .. "（" .. POINT_SYSTEM.effective_date .. tr(" 版）。"))
    end, function()
        for _, root in ipairs(job.objects) do
            local object = root.object
            if not object or object.isDestroyed() then return false end
            if object.loading_custom or object.getBoundsNormalized().size.x <= 0 then return false end
        end
        return true
    end, 60, function()
        if activeJob == job then
            finishJob(tr("牌組は生成済みです。画像読み込みが未完了のため枚数の最終確認を中止しました。"))
        end
    end)
end

local function spawnCopies(job)
    local ok, plans = pcall(buildImportObjects, job)
    if not ok then finishJob(tostring(plans)); return end
    job.pending = #plans
    for index, plan in ipairs(plans) do
        if activeJob ~= job then return end
        local root = {pile = plan.pile, count = plan.count, position = plan.position, completed = false}
        job.objects[index] = root
        local spawned, object = pcall(spawnObjectData, {data = plan.data,
            callback_function = function(created)
                -- A repeated completion must never advance the job or assign another identity.
                if root.completed then return end
                root.completed = true
                if root.timer then Wait.stop(root.timer) end
                if activeJob ~= job then return end
                root.object = created
                job.pending = job.pending - 1
                if job.pending == 0 then completeSpawn(job) end
            end})
        if not spawned then finishJob(tr("生成途中で停止：") .. tostring(object)); return end
        root.object = root.object or object
        if not root.completed then
            root.timer = Wait.time(function()
                if activeJob == job and not root.completed then
                    finishJob(tr("牌組の生成がタイムアウトしました。生成済みの物体は保持されています。"))
                end
            end, 30)
        end
    end
end

function openLovecaImporter(player, value, id)
    showLovecaPanel("import")
end

function closeLovecaImporter(player, value, id)
    -- Hide only: keep the input, status, and any running import intact.
    closeLovecaPanel("import")
end

function lovecaImportChanged(player, value, id)
    importText = normalizeCardNumber(value)
end

function importCards(player, value, id)
    if running then return end
    local ok, entries, total = pcall(parseList, importText)
    if not ok then status(tostring(entries)); return end
    running = true
    UI.setAttribute("lc_import_button", "interactable", "false")
    local job = {total = total, copies = {}, objects = {}, points = 0}
    activeJob = job
    local index = 0
    local function resolveNext()
        if activeJob ~= job then return end
        index = index + 1
        if index > #entries then
            batchSequence = recoveredSequence() + 1
            job.id = "loveca.import." .. batchSequence
            status(tr("カードを生成しています：") .. total .. tr(" 枚"))
            spawnCopies(job)
            return
        end
        local entry = entries[index]
        status(tr("確認中 ") .. index .. "/" .. #entries .. "：" .. entry.number)
        fetchSource(entry.number, function(source, message)
            if activeJob ~= job then return end
            if not source then finishJob(message .. tr("。カードは生成していません。")); return end
            local built, card = pcall(buildCardData, source)
            if not built then finishJob(tostring(card) .. tr("。カードは生成していません。")); return end
            job.points = job.points + card.loveca_point * entry.count
            for _ = 1, entry.count do
                table.insert(job.copies, {source = source, count = entry.count,
                    pile = source.type == "エネルギー" and "energy" or "main"})
            end
            resolveNext()
        end)
    end
    resolveNext()
end

function onSave()
    return encodeJSON({schema = "loveca.importer", version = 1,
        input = importText, batch_sequence = batchSequence, language = LANGUAGE, locale_version = 1, field = fieldSave(), markers = saveLovecaMarkers()})
end

local function localeUI()
    local children = {
        fieldNode("Text", {text = tr("言語を選択"), fontSize = "22", color = "#FFFFFF", width = "360", height = "35",
            rectAlignment = "UpperLeft", alignment = "MiddleLeft", offsetXY = "20 -10"}),
        fieldNode("Button", {text = "×", onClick = "closeLovecaLanguage", width = "34", height = "34", fontSize = "24",
            rectAlignment = "UpperRight", offsetXY = "-12 -8", color = "#3A4560", textColor = "#FFFFFF"}),
        fieldNode("Text", {text = tr("全員に適用・保存時に記録"), fontSize = "17", color = "#D5DDEA", width = "430", height = "28",
            rectAlignment = "UpperLeft", alignment = "MiddleLeft", offsetXY = "20 -54"})
    }
    for i, option in ipairs({{"zh", "中文"}, {"ja", "日本語"}, {"en", "English"}}) do
        table.insert(children, fieldNode("Button", {id = "lc_locale_" .. option[1], text = option[2],
            onClick = "selectLovecaLanguage", width = "136", height = "46", fontSize = "21", textColor = "#FFFFFF",
            color = LANGUAGE == option[1] and "#3C7565" or "#35445B", rectAlignment = "UpperLeft",
            offsetXY = (20 + (i - 1) * 147) .. " -104"}))
    end
    return {
        fieldNode("Button", {id = "lc_locale_launcher", text = tr("言語"), onClick = "openLovecaLanguage",
            width = "160", height = "44", rectAlignment = "UpperLeft", offsetXY = "80 -370", fontSize = "18",
            color = "#465571", textColor = "#FFFFFF"}),
        fieldNode("Panel", {id = "lc_locale_panel", width = "470", height = "180", rectAlignment = "UpperLeft",
            offsetXY = LOVECA_PANEL_OFFSET, color = "#202735F5", allowDragging = "true", active = "false"}, children)
    }
end

local localeGeneration = 0
local function installLovecaUI(active)
    -- Replace only our roots; retain unrelated UI and its custom assets.
    local ui = {}
    for _, node in ipairs(UI.getXmlTable()) do
        local id = (node.attributes or {}).id or ""
        if not string.match(id, "^lc_import_") and not string.match(id, "^lc_field_")
            and not string.match(id, "^lc_marker_") and not string.match(id, "^lc_locale_") then table.insert(ui, node) end
    end
    table.insert(ui, fieldNode("Button", {id = "lc_import_launcher", onClick = "openLovecaImporter", text = tr("デッキ導入"),
        width = "160", height = "44", rectAlignment = "UpperLeft", offsetXY = "80 -80", fontSize = "18",
        color = "#324268", textColor = "#FFFFFF", tooltip = tr("デッキ導入")}))
    table.insert(ui, fieldNode("Panel", {id = "lc_import_panel", width = "470", height = "410", rectAlignment = "UpperLeft",
        offsetXY = LOVECA_PANEL_OFFSET, color = "#202735EE", allowDragging = "true", active = "false"}, {
        fieldNode("Text", {text = tr("LoveCa デッキ導入"), fontSize = "22", color = "#FFFFFF", width = "380", height = "35",
            alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "20 -8"}),
        fieldNode("Button", {id = "lc_import_close", onClick = "closeLovecaImporter", text = "×", width = "34", height = "34",
            rectAlignment = "UpperRight", offsetXY = "-12 -8", fontSize = "24", color = "#3A4560", textColor = "#FFFFFF", tooltip = tr("閉じる")}),
        fieldNode("Text", {text = tr("カード番号 枚数（1行1種類）"), fontSize = "16", color = "#FFFFFF",
            rectAlignment = "UpperCenter", offsetXY = "0 -60", height = "25"}),
        fieldNode("InputField", {id = "lc_import_input", onValueChanged = "lovecaImportChanged", lineType = "MultiLineNewLine",
            fontSize = "18", characterLimit = "12000", width = "430", height = "180", rectAlignment = "UpperCenter",
            offsetXY = "0 -90", textColor = "#151515", text = importText}),
        fieldNode("Button", {id = "lc_import_button", onClick = "importCards", text = tr("デッキ導入"), interactable = running and "false" or "true", width = "200", height = "38",
            rectAlignment = "UpperCenter", offsetXY = "0 -280", fontSize = "18", color = "#324268", textColor = "#FFFFFF"}),
        fieldNode("Text", {id = "lc_import_status", text = importStatusText or tr("準備完了（読込時には自動生成しません）"), width = "430", height = "60",
            rectAlignment = "UpperCenter", offsetXY = "0 -333", fontSize = "15", color = "#FFFFFF"})
    }))
    for _, node in ipairs(fieldUI()) do table.insert(ui, node) end
    for _, node in ipairs(lovecaMarkerUI()) do table.insert(ui, node) end
    for _, node in ipairs(localeUI()) do table.insert(ui, node) end
    UI.setXmlTable(ui)
    localeGeneration = localeGeneration + 1
    local generation = localeGeneration
    Wait.condition(function()
        if generation ~= localeGeneration then return end
        showLovecaPanel(active)
        markerFormRender()
        refreshLovecaField()
    end, function() return not UI.loading end)
end

function getLovecaLanguage()
    return LANGUAGE
end

function openLovecaLanguage()
    showLovecaPanel("locale")
end

function closeLovecaLanguage()
    closeLovecaPanel("locale")
end

function selectLovecaLanguage(player, value, id)
    local language = string.match(id or "", "^lc_locale_(%w+)$")
    if not isLovecaLanguage(language) or language == LANGUAGE then return end
    LANGUAGE, LovecaLanguage = language, language
    refreshFieldLanguage()
    installLovecaUI(markerPanel)
    refreshMarkerLanguage()
    refreshCardLanguage()
end

function onLoad(saved_data)
    local fieldState = nil
    local markerState = nil
    if saved_data and saved_data ~= "" then
        local ok, state = pcall(decodeJSON, saved_data)
        if ok and type(state) == "table" and state.schema == "loveca.importer" then
            if state.locale_version == 1 and isLovecaLanguage(state.language) then
                LANGUAGE = state.language
            end
            if type(state.input) == "string" then importText = normalizeCardNumber(state.input) end
            batchSequence = tonumber(state.batch_sequence) or 0
            fieldState = state.field
            markerState = state.markers
        end
    end
    for _, source in ipairs(SAMPLE_CARDS) do sourceCache[normalizeNumber(source.card_no)] = source end
    LovecaLanguage = LANGUAGE
    installLovecaUI(nil)
    fieldLoad(fieldState)
    initializeLovecaMarkers(markerState)
    refreshCardLanguage()
end
