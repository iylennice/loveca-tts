-- LoveCa three-card smoke check. Paste this entire file into TTS Global.
-- Source records were extracted from bounded JSON samples, never the whole database.
-- Card data and presentation persist on each card; no object script is needed.
-- If Global already contains a script, use a separate test save to keep that script.

local BACK_URL = "https://loveca.lovelivefun.xyz/back.jpg"
local MIRROR_ROOT = "https://raw.githubusercontent.com/wlt233/llocg_db/master/"
local SPAWN_POSITIONS = {{0, 3, 0}, {5, 3, 0}, {10, 3, 0}}
local CARD_SCALE = {1, 1, 1} -- Use the same model multiplier for cards that will share a deck.
-- All three rendered faces are portrait PNGs on a 451 x 629 canvas.
-- Public transformation URLs are used by every player; no local asset path is required.
local RENDERED_FACES = {
    ["PL!-bp3-021-SRL"] = "https://wsrv.nl/?url=https%3A%2F%2Fraw.githubusercontent.com%2Fwlt233%2Fllocg_db%2Fmaster%2Fimg%2Fcards%2FPBLL02%2FPL%21-bp3-021-SRL.png&ro=90&output=png",
    ["PL!S-PR-034-PR＋"] = "https://wsrv.nl/?url=https%3A%2F%2Fraw.githubusercontent.com%2Fwlt233%2Fllocg_db%2Fmaster%2Fimg%2Fcards%2FPR%2FPL%21S-PR-034-PR2.png&w=451&h=629&fit=fill&output=png"
}
local LANGUAGE = "ja" -- Fill translations[language] later; empty text falls back to Japanese.
local spawning = {}
local trackedCards = {}
local sizeReportPending = false

local SOURCE_CARDS_JSON = [=[
[
    {
        "card_no": "PL!-bp3-021-SRL",
        "img": "https://llofficial-cardgame.com/wordpress/wp-content/images/cardlist/PBLL02/PL!-bp3-021-SRL.png",
        "name": "愛してるばんざーい!",
        "product": "プレミアムブースター ラブライブ！DUO",
        "type": "ライブ",
        "rare": "SRL",
        "series": "ラブライブ！",
        "score": 6,
        "need_heart": {
            "heart0": 7,
            "heart01": 3,
            "heart06": 4
        },
        "blade_heart": {
            "b_heart06": 1
        },
        "special_heart": {
            "draw": 1
        },
        "faq": [],
        "rare_list": [
            {
                "card_no": "PL!-bp3-021-SRL",
                "name": "愛してるばんざーい!"
            },
            {
                "card_no": "PL!-bp3-021-L",
                "name": "愛してるばんざーい!"
            }
        ],
        "_img": "img/cards/PBLL02/PL!-bp3-021-SRL.png"
    },
    {
        "card_no": "PL!-pb2-000-R",
        "img": "https://llofficial-cardgame.com/wordpress/wp-content/images/cardlist/PBLL02/PL!-pb2-000-R.png",
        "name": "星空 凛&小泉花陽",
        "product": "プレミアムブースター ラブライブ！DUO",
        "type": "メンバー",
        "rare": "R",
        "series": "ラブライブ！",
        "cost": 15,
        "base_heart": {
            "heart01": 2,
            "heart03": 2,
            "heart06": 1
        },
        "blade_heart": {
            "b_heart03": 1
        },
        "blade": 7,
        "ability": "{{jyouji.png|常時}}このカードのプレイに際し、2人のメンバーとバトンタッチしてもよい。 \n{{toujyou.png|登場}}『μ's』のメンバー2人からバトンタッチして登場した場合、自分の控え室にある『μ's』のライブカードを1枚手札に加え、さらに、そのメンバー2人のコストの合計が15の場合、ライブ終了時まで、「{{jyouji.png|常時}}ライブの合計スコアを＋１する。」を得る。",
        "faq": [],
        "rare_list": [
            {
                "card_no": "PL!-pb2-000-R",
                "name": "星空 凛&小泉花陽"
            },
            {
                "card_no": "PL!-pb2-000-DUO",
                "name": "星空 凛&小泉花陽"
            }
        ],
        "_img": "img/cards/PBLL02/PL!-pb2-000-R.png"
    },
    {
        "card_no": "PL!S-PR-034-PR＋",
        "img": "https://llofficial-cardgame.com/wordpress/wp-content/images/cardlist/PR/PL!S-PR-034-PR2.png",
        "name": "",
        "product": "PRカード",
        "type": "エネルギー",
        "rare": "PR+",
        "series": "ラブライブ！サンシャイン!!",
        "unit": "CYaRon！",
        "faq": [],
        "rare_list": [
            {
                "card_no": "PL!S-PR-034-PR＋",
                "name": ""
            }
        ],
        "_img": "img/cards/PR/PL!S-PR-034-PR2.png"
    }
]
]=]

local SAMPLE_POINTS = {
    ["PL!-bp3-021"] = 0,
    ["PL!-pb2-000"] = 0,
    ["PL!S-PR-034"] = 0
}

local HEARTS = {
    {"01", "桃"}, {"02", "赤"}, {"03", "黄"},
    {"04", "緑"}, {"05", "青"}, {"06", "紫"}
}

local function copy(value)
    return JSON.decode(JSON.encode(value))
end

local function testId(card)
    -- Keep the existing Live test card's identifier unchanged.
    return "loveca.single_card." .. card.card_no .. ".v1"
end

local function baseCardNumber(card)
    local base, suffix = string.match(card.card_no, "^(.*)%-([^%-]+)$")
    local normalizedSuffix = suffix and string.gsub(suffix, "＋", "+")
    local normalizedRarity = string.gsub(card.rare, "＋", "+")
    if not base or normalizedSuffix ~= normalizedRarity then
        error("カード番号とレアリティが一致しません：" .. card.card_no)
    end
    -- Original card_no and rare remain unchanged, including their original plus signs.
    return base
end

local function faceURL(card)
    -- The source record supplies the repository path; do not derive filenames from rarity.
    return RENDERED_FACES[card.card_no] or (MIRROR_ROOT .. card._img)
end

local function buildCardData(source)
    local card = copy(source)
    card.schema = "loveca.card"
    card.schema_version = 1
    card.test_id = testId(source)
    card.base_card_no = baseCardNumber(source)
    card.face_img = faceURL(source)
    card.preview_sideways = source.type == "ライブ"
    card.face_canvas = {width = 451, height = 629}
    card.back_img = BACK_URL
    card.language = LANGUAGE
    card.source = {
        url = "https://raw.githubusercontent.com/wlt233/llocg_db/refs/heads/master/json/cards.json",
        sampled_on = "2026-10-15"
    }

    -- Only these three verified samples have a point value here.
    -- Unknown/unmatched cards must not automatically become zero.
    card.loveca_point = SAMPLE_POINTS[card.base_card_no]
    card.point_system = {
        source = "https://llofficial-cardgame.com/lovecapointsystem/",
        effective_date = "2026-08-08",
        deck_limit = 9
    }
    card.printed = {
        cost = card.cost,
        blade = card.blade,
        score = card.score,
        base_heart = copy(card.base_heart or {}),
        need_heart = copy(card.need_heart or {}),
        blade_heart = copy(card.blade_heart or {}),
        special_heart = copy(card.special_heart or {})
    }
    card.current = copy(card.printed)
    card.modifiers = {}

    -- Original Japanese name and ability stay in the source fields.
    -- Translations affect presentation only, never identity or numerical calculations.
    card.translations = {zh = {name = "", ability = ""}}
    return card
end

local function textFor(card, field)
    local translation = card.translations[LANGUAGE]
    if translation and translation[field] and translation[field] ~= "" then
        return translation[field]
    end
    return card[field] or ""
end

local function displayName(card)
    local name = textFor(card, "name")
    if name == "" and card.type == "エネルギー" then
        return "エネルギー" -- Display fallback only; keep the source name empty.
    end
    return name
end

local function displayAbility(ability)
    if ability == "" then return "なし" end
    -- This member sample only uses these two trigger icons.
    -- Preserve all original wording, numbers, conditions, and duration.
    local triggers = {
        ["jyouji.png"] = "【常時】",
        ["toujyou.png"] = "【登場】"
    }
    local parts = {}
    local cursor = 1
    while cursor <= #ability do
        local first = string.find(ability, "{{", cursor, true)
        if not first then
            table.insert(parts, string.sub(ability, cursor))
            break
        end
        table.insert(parts, string.sub(ability, cursor, first - 1))
        local last = string.find(ability, "}}", first + 2, true)
        if not last then
            table.insert(parts, string.sub(ability, first))
            break
        end

        local token = string.sub(ability, first + 2, last - 1)
        local separator = string.find(token, "|", 1, true)
        if separator then
            local file = string.sub(token, 1, separator - 1)
            local alternative = string.sub(token, separator + 1)
            local replacement = triggers[file]
            if not replacement then
                replacement = alternative ~= "" and alternative or ("[" .. file .. "]")
            end
            table.insert(parts, replacement)
        else
            table.insert(parts, string.sub(ability, first, last + 1))
        end
        cursor = last + 2
    end
    return table.concat(parts)
end

local function heartText(values, prefix, isRequirement)
    local parts = {}
    for _, colour in ipairs(HEARTS) do
        local count = values[prefix .. colour[1]] or 0
        if count ~= 0 then
            table.insert(parts, colour[2] .. "×" .. tostring(count))
        end
    end
    if isRequirement then
        if (values.heart0 or 0) ~= 0 then
            table.insert(parts, "無指定×" .. tostring(values.heart0))
        end
    else
        if (values.b_heart07 or 0) ~= 0 then
            table.insert(parts, "無色×" .. tostring(values.b_heart07))
        end
        if (values.b_all or 0) ~= 0 then
            table.insert(parts, "ALL×" .. tostring(values.b_all))
        end
    end
    return #parts > 0 and table.concat(parts, "／") or "なし"
end

local function descriptionFor(card)
    local current = card.current
    local lines = {"種類：" .. card.type}
    if card.type == "メンバー" then
        table.insert(lines, "コスト：" .. tostring(current.cost))
        table.insert(lines, "ハート：" .. heartText(current.base_heart, "heart", false))
        table.insert(lines, "ブレード：" .. tostring(current.blade))
    elseif card.type == "ライブ" then
        table.insert(lines, "スコア：" .. tostring(current.score))
        table.insert(lines, "必要ハート：" .. heartText(current.need_heart, "heart", true))
    elseif card.type == "エネルギー" then
        table.insert(lines, "コスト：—")
        table.insert(lines, "ハート：—")
        table.insert(lines, "ブレード：—")
    end

    if card.type ~= "エネルギー" then
        table.insert(lines, "ブレードハート：" .. heartText(current.blade_heart, "b_heart", false))
        table.insert(lines, "エール加点：" .. tostring(current.special_heart.score or 0))
        table.insert(lines, "エールドロー：" .. tostring(current.special_heart.draw or 0))
    end
    table.insert(lines, "ラブカポイント：" .. tostring(card.loveca_point))
    table.insert(lines, "")
    table.insert(lines, "能力：")
    table.insert(lines, displayAbility(textFor(card, "ability")))
    table.insert(lines, "")
    table.insert(lines, "作品：" .. (card.series or "—"))
    table.insert(lines, "ユニット：" .. (card.unit and card.unit ~= "" and card.unit or "—"))
    table.insert(lines, "収録商品：" .. (card.product or "—"))
    return table.concat(lines, "\n")
end

local function applyCardPresentation(object, card)
    object.setScale(CARD_SCALE)
    object.setName(displayName(card) .. " [" .. card.base_card_no .. "] [" .. card.rare .. "]")
    object.setDescription(descriptionFor(card))

    -- Preserve unrelated tags. Empty source names do not become fallback-name tags.
    for _, field in ipairs({"name", "series", "unit", "product"}) do
        local value = card[field]
        if value and value ~= "" then object.addTag(value) end
    end
    object.tooltip = true
end

local function applyCardData(object, source)
    local card = buildCardData(source)
    applyCardPresentation(object, card)
    object.memo = JSON.encode(card)
end

local function isTestCard(memo, id)
    if type(memo) ~= "string" or memo == "" then return false end
    local ok, data = pcall(JSON.decode, memo)
    return ok and type(data) == "table" and data.test_id == id
end

local function findTestCard(id)
    for _, object in ipairs(getObjects()) do
        if isTestCard(object.memo, id) then return object end
        if object.type == "Deck" then
            for _, contained in ipairs(object.getObjects()) do
                if isTestCard(contained.memo, id) then return object end
            end
        end
    end
    return nil
end

local function customCardParameters(source)
    return {
        type = 0,
        face = faceURL(source),
        back = BACK_URL,
        sideways = source.type == "ライブ" -- ALT preview for the rotated portrait Live face.
    }
end

local function initialRotation(source)
    -- The Live art is clockwise 90 degrees inside a portrait card model.
    -- Turn the table object back by 90 degrees relative to the other samples.
    return {0, source.type == "ライブ" and 90 or 180, 0}
end

local function ensureTestCard(source, position)
    local id = testId(source)
    if spawning[id] then return end
    local existing = findTestCard(id)
    if existing then
        if existing.type == "Deck" then
            trackedCards[id] = nil
            print(source.card_no .. "：テストカードはデッキ内にあります。")
            return
        end

        -- Re-render persisted objects too; a script update must not leave old descriptions behind.
        local data = JSON.decode(existing.memo)
        applyCardPresentation(existing, data)
        local custom = existing.getCustomObject()
        local parameters = customCardParameters(source)
        data.face_img = faceURL(source)
        data.back_img = BACK_URL
        data.preview_sideways = parameters.sideways
        data.face_canvas = {width = 451, height = 629}
        existing.memo = JSON.encode(data)
        if custom.face ~= parameters.face or custom.back ~= parameters.back
            or (custom.sideways == true) ~= parameters.sideways then
            -- Keep existing numerical values and other metadata when repairing an image.
            existing.setCustomObject(parameters)
            if source.type == "ライブ" then
                local rotation = existing.getRotation()
                existing.setRotation({rotation.x, initialRotation(source)[2], rotation.z})
            end
            trackedCards[id] = existing.reload() -- Keep the replacement reference for size measurement.
            print(source.card_no .. "：テストカードの画像を更新しました。")
        else
            trackedCards[id] = existing
            print(source.card_no .. "：テストカードの表示を更新しました。")
        end
        return
    end

    spawning[id] = true
    local object = spawnObject({
        type = "CardCustom",
        position = position,
        rotation = initialRotation(source),
        scale = CARD_SCALE,
        sound = false,
        callback_function = function(spawned)
            applyCardData(spawned, source)
            trackedCards[id] = spawned
            spawning[id] = nil
            print("テストカードを生成しました：" .. spawned.getName())
        end
    })
    -- Official API requires setting custom parameters immediately after spawnObject.
    object.setCustomObject(customCardParameters(source))
end

local function reportCardSizes(sources)
    if sizeReportPending then return end
    sizeReportPending = true
    -- Custom card geometry may not be ready until its image download has completed.
    Wait.condition(function()
        sizeReportPending = false
        for _, source in ipairs(sources) do
            local object = trackedCards[testId(source)]
            local size = object.getBoundsNormalized().size
            local scale = object.getScale()
            print(string.format("%s：寸法 %.3f×%.3f / スケール %.3f, %.3f, %.3f",
                source.type, size.x, size.z, scale.x, scale.y, scale.z))
        end
    end, function()
        for _, source in ipairs(sources) do
            local object = trackedCards[testId(source)]
            if not object or object.isDestroyed() or object.loading_custom then return false end
            local size = object.getBoundsNormalized().size
            if size.x <= 0 or size.z <= 0 then return false end
        end
        return true
    end, 30, function()
        sizeReportPending = false
        print("サイズ確認に必要なカードが未準備です。画像の読み込みを確認し、デッキ内のカードは取り出して再実行してください。")
    end)
end

function spawnTestCard()
    local sources = JSON.decode(SOURCE_CARDS_JSON)
    for index, source in ipairs(sources) do
        ensureTestCard(source, SPAWN_POSITIONS[index])
    end
    reportCardSizes(sources)
end

function onLoad(saved_data)
    spawnTestCard()
end
