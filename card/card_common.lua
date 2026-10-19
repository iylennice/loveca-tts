-- Shared LoveCa card data and presentation. Bundled by tools/build_importer.py.
local BACK_URL = "https://loveca.lovelivefun.xyz/back.jpg"
local MIRROR_ROOT = "https://raw.githubusercontent.com/wlt233/llocg_db/master/"
local CARD_SCALE = {1, 1, 1} -- Use the same model multiplier for cards that will share a deck.
-- All three rendered faces are portrait PNGs on a 451 x 629 canvas.
-- Public transformation URLs are used by every player; no local asset path is required.
local RENDERED_FACES = {
    ["PL!-bp3-021-SRL"] = "https://wsrv.nl/?url=https%3A%2F%2Fraw.githubusercontent.com%2Fwlt233%2Fllocg_db%2Fmaster%2Fimg%2Fcards%2FPBLL02%2FPL%21-bp3-021-SRL.png&ro=90&output=png",
    ["PL!S-PR-034-PR＋"] = "https://wsrv.nl/?url=https%3A%2F%2Fraw.githubusercontent.com%2Fwlt233%2Fllocg_db%2Fmaster%2Fimg%2Fcards%2FPR%2FPL%21S-PR-034-PR2.png&w=451&h=629&fit=fill&output=png"
}

local HEARTS = {
    {"01", "桃"}, {"02", "赤"}, {"03", "黄"},
    {"04", "緑"}, {"05", "青"}, {"06", "紫"}
}

local function copy(value)
    if type(value) ~= "table" then return value end
    local result = {}
    for key, item in pairs(value) do result[copy(key)] = copy(item) end
    return result
end

-- TTS UI strings may use a native Unicode character; JSON/source strings may use
-- three UTF-8 bytes. MoonSharp supports string.char(0xFF0B); standard Lua may not.
local FULLWIDTH_PLUS_BYTES = string.char(239, 188, 139)
local nativePlusAvailable, FULLWIDTH_PLUS_NATIVE = pcall(string.char, 0xFF0B)

local function unicodeCharacter(code)
    if code < 0 or code > 0x10FFFF or (code >= 0xD800 and code <= 0xDFFF) then code = 0xFFFD end
    if nativePlusAvailable then
        if code <= 0xFFFF then return string.char(code) end
        -- TTS uses native UTF-16 strings; supplementary characters require a surrogate pair.
        local supplementary = code - 0x10000
        return string.char(0xD800 + math.floor(supplementary / 1024), 0xDC00 + supplementary % 1024)
    end
    -- Standard Lua uses UTF-8 bytes, so retain its usual string representation.
    if code < 128 then return string.char(code) end
    if code < 2048 then return string.char(192 + math.floor(code / 64), 128 + code % 64) end
    if code < 65536 then
        return string.char(224 + math.floor(code / 4096), 128 + math.floor(code / 64) % 64, 128 + code % 64)
    end
    return string.char(240 + math.floor(code / 262144), 128 + math.floor(code / 4096) % 64,
        128 + math.floor(code / 64) % 64, 128 + code % 64)
end

local function nativeUTF8Text(value)
    if not nativePlusAvailable then return value end
    local parts, index = {}, 1
    while index <= #value do
        local first = string.byte(value, index)
        if first < 128 then
            -- Preserve characters already supplied as native Unicode; string.byte may report '?'.
            table.insert(parts, string.sub(value, index, index))
            index = index + 1
        else
            local length, minimum, code
            if first >= 194 and first <= 223 then length, minimum, code = 2, 128, first - 192
            elseif first >= 224 and first <= 239 then length, minimum, code = 3, 2048, first - 224
            elseif first >= 240 and first <= 244 then length, minimum, code = 4, 65536, first - 240
            else return value end -- Invalid UTF-8 or an existing native Latin-1 character: preserve it.
            if index + length - 1 > #value then return value end
            for offset = 1, length - 1 do
                local byte = string.byte(value, index + offset)
                if byte < 128 or byte > 191 then return value end
                code = code * 64 + byte - 128
            end
            if code < minimum or code > 0x10FFFF or (code >= 0xD800 and code <= 0xDFFF) then return value end
            table.insert(parts, unicodeCharacter(code))
            index = index + length
        end
    end
    return table.concat(parts)
end

local function nativeJSONText(value)
    if type(value) == "string" then return nativeUTF8Text(value) end
    if type(value) ~= "table" then return value end
    local result = {}
    for key, item in pairs(value) do result[nativeJSONText(key)] = nativeJSONText(item) end
    return result
end

local function encodeJSON(value)
    if not nativePlusAvailable then return JSON.encode(value) end
    -- TTS's encoder loses some native Unicode punctuation (e.g. U+3005).
    -- Give it ASCII strings while retaining its existing object/array/number
    -- handling; never replace the global JSON or string functions.
    local function escapeStrings(item)
        if type(item) == "string" then
            local parts = {}
            for index = 1, #item do
                local code = string.unicode(item, index) -- Native UTF-16 code unit, not string.byte.
                if code == 92 or code > 127 then
                    table.insert(parts, string.format("\\u%04x", code))
                else
                    table.insert(parts, string.sub(item, index, index))
                end
            end
            return table.concat(parts)
        end
        if type(item) ~= "table" then return item end
        local result = {}
        for key, child in pairs(item) do result[escapeStrings(key)] = escapeStrings(child) end
        return result
    end
    local encoded = JSON.encode(escapeStrings(value))
    -- The encoder escaped the backslashes we introduced. Unescape exactly
    -- those Unicode sequences. Original backslashes became \u005c first,
    -- so literal text such as "\u3005" is not mistaken for a character.
    return (string.gsub(encoded, "\\\\u(%x%x%x%x)", "\\u%1"))
end

local function decodeJSON(text)
    -- Escaped JSON characters decode as UTF-8 bytes in TTS; restore the native
    -- representation used by script literals, UI strings, and comparisons.
    return nativeJSONText(JSON.decode(text))
end

local function normalizeCardNumber(value)
    value = string.gsub(value, FULLWIDTH_PLUS_BYTES, "+")
    if nativePlusAvailable then value = string.gsub(value, FULLWIDTH_PLUS_NATIVE, "+") end
    return value
end

local function baseCardNumber(card)
    local base, suffix = string.match(card.card_no, "^(.*)%-([^%-]+)$")
    local normalizedSuffix = suffix and normalizeCardNumber(suffix)
    local normalizedRarity = normalizeCardNumber(card.rare)
    if not base or normalizedSuffix ~= normalizedRarity then
        error(tr("カード番号とレアリティが一致しません：") .. card.card_no)
    end
    -- Original card_no and rare remain unchanged, including their original plus signs.
    return base
end

local function escapeURL(value)
    return (string.gsub(value, "([^%w%-%._~])", function(character)
        return string.format("%%%02X", string.byte(character))
    end))
end

local function faceURL(card)
    -- The source record supplies the repository path; do not derive filenames from rarity.
    if RENDERED_FACES[card.card_no] then return RENDERED_FACES[card.card_no] end
    local mirror = MIRROR_ROOT .. card._img
    if card.card_no == "PL!-pb2-000-R" then return mirror end
    -- Normalize every new card to the tested portrait canvas, including unusual energy sizes.
    -- WSRV resizes BEFORE rotating: request a landscape canvas for Live art so
    -- its final 90-degree rotation produces the same 451 x 629 portrait face.
    local parameters = card.type == "ライブ" and "&w=629&h=451&ro=90" or "&w=451&h=629"
    return "https://wsrv.nl/?url=" .. escapeURL(mirror) .. parameters .. "&fit=fill&output=png"
end

local function buildCardData(source)
    local card = copy(source)
    card.schema = "loveca.card"
    card.schema_version = 1
    card.base_card_no = baseCardNumber(source)
    card.face_img = faceURL(source)
    -- Keep hand silhouettes identical; native sideways also affects hand layout.
    -- Live's tabletop orientation is controlled separately by initialRotation().
    card.preview_sideways = false
    card.face_canvas = {width = 451, height = 629}
    card.back_img = BACK_URL
    card.language = LANGUAGE
    card.source = copy(source.source or {url = "https://raw.githubusercontent.com/wlt233/llocg_db/refs/heads/master/json/cards.json", sampled_on = "2026-10-15"})

    -- This is the complete, previously verified official point-list snapshot.
    -- Unlisted cards are zero only within this explicit snapshot, not on lookup failure.
    card.loveca_point = POINT_SYSTEM.points[card.base_card_no] or 0
    card.point_system = {source = POINT_SYSTEM.source,
        effective_date = POINT_SYSTEM.effective_date, deck_limit = POINT_SYSTEM.deck_limit}
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
    card.translations = copy(source.translations or {})
    card.translations.zh = card.translations.zh or {name = "", ability = ""}
    card.translations.en = card.translations.en or {name = "", ability = ""}
    return card
end

local function textFor(card, field)
    local translation = (card.translations or {})[LANGUAGE]
    if translation and translation[field] and translation[field] ~= "" then
        return translation[field]
    end
    return card[field] or ""
end

local function displayName(card)
    local name = textFor(card, "name")
    if name == "" and card.type == "エネルギー" then
        return tr("エネルギー") -- Display fallback only; keep the source name empty.
    end
    return name
end

local function displayAbility(ability)
    if ability == "" then return tr("なし") end
    -- Only adjacent identical resource icons are counted together. Never combine
    -- resources across wording, line breaks, colours, or separate skill costs.
    -- The original token string in card.ability remains unchanged.
    local triggers = {
        ["jyouji.png"] = tr("【常時】"),
        ["toujyou.png"] = tr("【登場】"),
        ["kidou.png"] = tr("【起動】"), ["jidou.png"] = tr("【自動】"),
        ["live_start.png"] = tr("【ライブ開始時】"), ["live_success.png"] = tr("【ライブ成功時】"),
        ["center.png"] = tr("【センター】"), ["leftside.png"] = tr("【左サイド】"),
        ["rightside.png"] = tr("【右サイド】")
    }
    local resources = {
        ["heart_00.png"] = tr("無指定ハート"), ["icon_all.png"] = tr("ALLハート"),
        ["icon_blade.png"] = tr("ブレード"), ["icon_energy.png"] = tr("エネルギー")
    }
    for _, colour in ipairs(HEARTS) do resources["heart_" .. colour[1] .. ".png"] = tr(colour[2]) .. tr("ハート") end
    local parts = {}
    local pendingResource, pendingCount = nil, 0
    local function flushResource()
        if pendingResource then
            table.insert(parts, "【" .. pendingResource .. " x" .. tostring(pendingCount) .. "】")
            pendingResource, pendingCount = nil, 0
        end
    end
    local function appendText(text)
        if text == "" then return end
        flushResource()
        table.insert(parts, text)
    end
    local cursor = 1
    while cursor <= #ability do
        local first = string.find(ability, "{{", cursor, true)
        if not first then
            appendText(string.sub(ability, cursor))
            break
        end
        appendText(string.sub(ability, cursor, first - 1))
        local last = string.find(ability, "}}", first + 2, true)
        if not last then
            appendText(string.sub(ability, first))
            break
        end

        local token = string.sub(ability, first + 2, last - 1)
        local separator = string.find(token, "|", 1, true)
        if separator then
            local file = string.sub(token, 1, separator - 1)
            local alternative = string.sub(token, separator + 1)
            local resource = resources[file]
            if resource then
                if pendingResource ~= resource then flushResource() end
                pendingResource, pendingCount = resource, pendingCount + 1
            else
                local replacement = triggers[file]
                -- Fixed turn badges are labels, not ability prose or resources.
                if not replacement and string.match(file, "^turn%d+%.png$") and alternative ~= "" then
                    local turns = string.match(file, "^turn(%d+)%.png$")
                    replacement = "【" .. (LANGUAGE ~= "ja" and turns and string.format(tr("ターン%s回"), turns) or alternative) .. "】"
                end
                appendText(replacement or (alternative ~= "" and alternative or ("[" .. file .. "]")))
            end
        else
            appendText(string.sub(ability, first, last + 1))
        end
        cursor = last + 2
    end
    flushResource()
    return table.concat(parts)
end

local function heartText(values, prefix, isRequirement)
    local parts = {}
    for _, colour in ipairs(HEARTS) do
        local count = values[prefix .. colour[1]] or 0
        if count ~= 0 then
            table.insert(parts, tr(colour[2]) .. "×" .. tostring(count))
        end
    end
    if isRequirement then
        if (values.heart0 or 0) ~= 0 then
            table.insert(parts, tr("無指定×") .. tostring(values.heart0))
        end
    else
        if (values.b_heart07 or 0) ~= 0 then
            table.insert(parts, tr("無色×") .. tostring(values.b_heart07))
        end
        if (values.b_all or 0) ~= 0 then
            table.insert(parts, "ALL×" .. tostring(values.b_all))
        end
    end
    return #parts > 0 and table.concat(parts, "／") or tr("なし")
end

local function descriptionFor(card)
    local current = card.current
    local lines = {tr("種類：") .. tr(card.type)}
    if card.type == "メンバー" then
        table.insert(lines, tr("コスト：") .. tostring(current.cost))
        table.insert(lines, tr("ハート：") .. heartText(current.base_heart, "heart", false))
        table.insert(lines, tr("ブレード：") .. tostring(current.blade))
    elseif card.type == "ライブ" then
        table.insert(lines, tr("スコア：") .. tostring(current.score))
        table.insert(lines, tr("必要ハート：") .. heartText(current.need_heart, "heart", true))
    elseif card.type == "エネルギー" then
        table.insert(lines, tr("コスト：—"))
        table.insert(lines, tr("ハート：—"))
        table.insert(lines, tr("ブレード：—"))
    end

    if card.type ~= "エネルギー" then
        table.insert(lines, tr("ブレードハート：") .. heartText(current.blade_heart, "b_heart", false))
        table.insert(lines, tr("エール加点：") .. tostring(current.special_heart.score or 0))
        table.insert(lines, tr("エールドロー：") .. tostring(current.special_heart.draw or 0))
    end
    table.insert(lines, tr("ラブカポイント：") .. tostring(card.loveca_point))
    table.insert(lines, "")
    local translatedAbility = ((card.translations or {})[LANGUAGE] or {}).ability
    table.insert(lines, LANGUAGE ~= "ja" and (not translatedAbility or translatedAbility == "")
        and card.ability and card.ability ~= "" and string.format(tr("能力（%s）："), tr("日本語原文・未翻訳")) or tr("能力："))
    table.insert(lines, displayAbility(textFor(card, "ability")))
    table.insert(lines, "")
    table.insert(lines, tr("作品：") .. (card.series or "—"))
    table.insert(lines, tr("ユニット：") .. (card.unit and card.unit ~= "" and card.unit or "—"))
    table.insert(lines, tr("収録商品：") .. (card.product or "—"))
    return table.concat(lines, "\n")
end

local function cardTags(card)
    local tags, seen = {}, {}
    for _, field in ipairs({"name", "series", "unit", "product"}) do
        local value = card[field]
        if value and value ~= "" and not seen[value] then
            table.insert(tags, value)
            seen[value] = true
        end
    end
    return tags
end

local function applyCardPresentation(object, card)
    object.setName(displayName(card) .. " [" .. card.base_card_no .. "] [" .. card.rare .. "]")
    object.setDescription(descriptionFor(card))

    -- Preserve unrelated tags. Empty source names do not become fallback-name tags.
    for _, value in ipairs(cardTags(card)) do object.addTag(value) end
    object.tooltip = true
end

local function refreshCardPresentation(object)
    if not object or object.isDestroyed() then return end
    if object.type == "Card" then
        local ok, card = pcall(decodeJSON, object.memo or "")
        if ok and type(card) == "table" and card.schema == "loveca.card" and card.schema_version == 1 then
            applyCardPresentation(object, card)
        end
    elseif object.type == "Deck" then
        local ok, deck = pcall(decodeJSON, object.memo or "")
        if ok and type(deck) == "table" and deck.schema == "loveca.deck" and deck.schema_version == 1 then
            object.setName(deck.pile == "main" and tr("メインデッキ") or tr("エネルギーデッキ"))
            object.setDescription(tr("インポート ") .. tostring(deck.batch_id) .. " / " .. object.getQuantity() .. tr(" 枚"))
        end
    end
end

local function refreshCardLanguage()
    for _, object in ipairs(getObjects()) do refreshCardPresentation(object) end
end

-- Contained cards are updated on extraction without rebuilding/shuffling a deck.
function onObjectLeaveContainer(container, object)
    Wait.frames(function() refreshCardPresentation(object) end, 1)
end

function onObjectSpawn(object)
    Wait.frames(function() refreshCardPresentation(object) end, 1)
end

local function customCardParameters(source)
    return {
        type = 0,
        face = faceURL(source),
        back = BACK_URL,
        sideways = false -- No type-revealing sideways layout in players' hands.
    }
end

local function initialRotation(source)
    -- The Live art is clockwise 90 degrees inside a portrait card model.
    -- Turn the table object back by 90 degrees relative to the other samples.
    return {0, source.type == "ライブ" and 90 or 180, 0}
end

local function cardObjectData(card, definitionID)
    local rotation = initialRotation(card)
    local custom = {
        FaceURL = card.face_img, BackURL = card.back_img, NumWidth = 1, NumHeight = 1,
        BackIsHidden = true, UniqueBack = false, Type = 0
    }
    -- Native fields were checked against getData() from the working TTS cards.
    -- Memo is present before the object exists; a callback never assigns per-card identities.
    return {
        Name = "CardCustom", CardID = definitionID * 100,
        CustomDeck = {[tostring(definitionID)] = custom},
        Transform = {posX = 0, posY = 0, posZ = 0,
            rotX = rotation[1], rotY = rotation[2], rotZ = rotation[3],
            scaleX = CARD_SCALE[1], scaleY = CARD_SCALE[2], scaleZ = CARD_SCALE[3]},
        Nickname = displayName(card) .. " [" .. card.base_card_no .. "] [" .. card.rare .. "]",
        Description = descriptionFor(card), Memo = encodeJSON(card), Tags = cardTags(card),
        SidewaysCard = card.preview_sideways, ColorDiffuse = {r = 0.713235259, g = 0.713235259, b = 0.713235259, a = 1},
        Locked = false, Grid = true, Snap = true, Sticky = true, Tooltip = true,
        Hands = true, HideWhenFaceDown = true, DragSelectable = true,
        LuaScript = "", LuaScriptState = "", XmlUI = ""
    }
end
