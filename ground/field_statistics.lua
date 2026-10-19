-- Public field statistics. Regions are in each playmat's local coordinate system.
-- Skills, drawing, energy payment and card movement remain manual.
local FIELD_DEFAULTS = {version = 1, players = {
    {color = "White", mat = "0e661d"}, {color = "Pink", mat = "bab5f6"}
}}
local fieldConfig = copy(FIELD_DEFAULTS)
local fieldOwners, fieldCache, fieldSnapshot, fieldText = {}, {}, {}, {}
local fieldSticky = {}
local fieldMarkerBindings = {}
local fieldBlocked, initiativeWinner, initiativeText = {}, nil, ""
local LOVECA_PANEL_OFFSET = "250 -80" -- Shared top-left origin for all three panels.
local FIELD_SLOTS = {0.780, 0.017, -0.700}
local FIELD_LIVES = {0.695, -0.011, -0.698}
local FIELD_CHEER = {left = 1.94, right = 2.94, top = -0.80, bottom = 0.80}
local FIELD_SLOT_NAMES = {"左", "中", "右"}

local function fieldRegion(p)
    if p.y < -0.10 or p.y > 1.4 then return nil end
    if p.x >= FIELD_CHEER.left and p.x <= FIELD_CHEER.right
        and p.z >= FIELD_CHEER.top and p.z <= FIELD_CHEER.bottom then return "cheer" end
    -- The cheer area is on the table, lower than the playmat's top surface.
    if p.y < 0.07 then return nil end
    if p.z >= -0.94 and p.z <= -0.40 then
        for i, x in ipairs(FIELD_LIVES) do if math.abs(p.x - x) <= 0.31 then return "live", i end end
    end
    if p.z >= -0.38 and p.z <= 0.36 then
        for i, x in ipairs(FIELD_SLOTS) do if math.abs(p.x - x) <= 0.34 then return "stage", i end end
    end
    if p.x >= -1.04 and p.x <= 1.05 and p.z >= 0.39 and p.z <= 0.98 then return "energy" end
    if p.x >= -1.80 and p.x <= -1.18 then
        if p.z >= -0.96 and p.z <= -0.37 then return "main" end
        if p.z >= -0.34 and p.z <= 0.31 then return "waiting" end
        if p.z >= 0.36 and p.z <= 0.99 then return "energy_deck" end
    end
    if p.x >= 1.18 and p.x <= 1.80 and p.z >= -0.55 and p.z <= 0.20 then return "success" end
end

local function fieldIssue(sheet, section, message)
    sheet.complete[section] = false
    if not sheet.issueSet[message] then
        sheet.issueSet[message] = true
        table.insert(sheet.issues, message)
    end
end

local function fieldNumber(value)
    if type(value) ~= "number" or value ~= value or value < 0 or value == math.huge
        or value ~= math.floor(value) then error(tr("数値データが不正です")) end
    return value
end

local function fieldMap(value, keys)
    if type(value) ~= "table" then error(tr("ハートデータがありません")) end
    local result = {}
    for _, key in ipairs(keys) do result[key] = fieldNumber(value[key] == nil and 0 or value[key]) end
    return result
end

local FIELD_HEART_KEYS = {"heart01", "heart02", "heart03", "heart04", "heart05", "heart06", "heart0"}
local FIELD_CHEER_KEYS = {"b_heart01", "b_heart02", "b_heart03", "b_heart04",
    "b_heart05", "b_heart06", "b_heart07", "b_all"}

local function fieldCard(guid, memo)
    local cached = fieldCache[guid]
    if cached and cached.memo == memo then return cached.card end
    local ok, card = pcall(decodeJSON, memo or "")
    if not ok or type(card) ~= "table" or card.schema ~= "loveca.card" or card.schema_version ~= 1
        or type(card.instance_id) ~= "string" or card.instance_id == ""
        or type(card.current) ~= "table" then return nil end
    fieldCache[guid] = {memo = memo, card = card}
    return card
end

local function fieldAdd(target, values)
    for key, value in pairs(values) do target[key] = (target[key] or 0) + value end
end

local function fieldState(object, mat)
    if object.getTransformUp().y < 0.94 then return "unknown" end
    local angle = (object.getRotation().y - mat.getRotation().y) % 180
    if math.min(angle, 180 - angle) <= 20 then return "active" end
    if math.abs(angle - 90) <= 20 then return "wait" end
    return "unknown"
end

local function fieldSheet(player)
    return {color = player.color, mat = player.mat, issues = {}, issueSet = {},
        modifiers = {member = {{}, {}, {}}, live = {{}, {}, {}}, cheer = {}, score = {}, count = 0},
        complete = {stage = true, live = true, cheer = true, energy = true},
        judgement = {status = "pending", message = tr("未判定\n集計中")},
        stage = {hearts = {}, blade = 0, count = 0, active = 0, wait = 0, slots = {}},
        live = {hearts = {}, score = 0, count = 0, hidden = 0, slots = {}},
        cheer = {hearts = {}, score = 0, draw = 0, count = 0, hidden = 0},
        energy = {active = 0, wait = 0, unknown = 0, total = 0}}
end

local function fieldMarkerSection(scope)
    if scope == "member" then return "stage" end
    if scope == "score" then return "live" end
    if scope == "live" or scope == "cheer" then return scope end
end

local function fieldExactSum(base, change)
    local limit = 9007199254740991
    if (change > 0 and base > limit - change) or (change < 0 and base < -limit - change) then return nil end
    return base + change
end

local function fieldAdjusted(sheet, section, base, change)
    local value = fieldExactSum(base, change)
    if value then return value end
    fieldIssue(sheet, section, tr("補正後の数値が整数範囲外"))
    return base -- Incomplete result; never present a rounded integer as exact.
end

-- A marker targets the visible card present when it is placed, not whichever
-- card later occupies the same slot. Storage/unassigned placement releases it.
-- Bindings are automatic; players never have to enter a card GUID.
local function fieldMarkerTarget(sheet, marker)
    local p = marker.placement
    if p.scope ~= "member" and p.scope ~= "live" then return true end
    local section = fieldMarkerSection(p.scope)
    local card = sheet[section].slots[p.slot]
    local subject = card and (card.guid .. "/" .. card.instance_id) or ""
    local binding = fieldMarkerBindings[marker.guid]
    if not binding or binding.color ~= p.color or binding.scope ~= p.scope or binding.slot ~= p.slot then
        binding = {color = p.color, scope = p.scope, slot = p.slot, subject = subject}
        fieldMarkerBindings[marker.guid] = binding
    end
    if not card then
        fieldIssue(sheet, section, tr("補正対象の公開カードを確認：") .. marker.guid)
        return false
    end
    if binding.subject ~= subject then
        fieldIssue(sheet, section, tr("補正対象が交代：保管へ戻して置き直す（") .. marker.guid .. "）")
        return false
    end
    return true
end

local function fieldCollectMarkers(sheets)
    local byColor, seen = {}, {}
    for _, sheet in ipairs(sheets) do byColor[sheet.color] = sheet end
    local reasons = {moving = tr("マーカー移動中"), ambiguous = tr("マーカーの領域が重複"),
        wrong_resource = tr("領域とマーカー種類が不一致"), invalid_data = tr("マーカーデータが不正"),
        duplicate = tr("マーカー個体番号が重複")}
    for _, marker in ipairs(refreshLovecaMarkers(fieldConfig.players)) do
        local p, guid = marker.placement, marker.guid
        seen[guid] = true
        if p.code == "unassigned" or (p.code == "placed" and p.scope == "storage") then
            fieldMarkerBindings[guid] = nil
        elseif marker.value == 0 and p.code == "placed" then
            fieldMarkerBindings[guid] = nil
        else
            local sheet, section = byColor[p.color], fieldMarkerSection(p.scope)
            if p.code ~= "placed" then
                local function report(color, scope)
                    local affected = byColor[color]
                    local region = fieldMarkerSection(scope)
                    if affected and region then fieldIssue(affected, region, tr(reasons[p.code] or "マーカーを確認") .. "：" .. guid) end
                end
                report(p.color, p.scope)
                for _, match in ipairs(p.matches or {}) do report(match.color, match.scope) end
                local previous = fieldMarkerBindings[guid]
                if previous then report(previous.color, previous.scope) end
            elseif sheet and section and fieldMarkerTarget(sheet, marker) then
                local bucket = sheet.modifiers[p.scope]
                if p.slot then bucket = bucket[p.slot] end
                local resource = marker.resource
                local sum = fieldExactSum(bucket[resource] or 0, marker.value)
                if sum == nil then
                    fieldIssue(sheet, section, tr("補正の合計が整数範囲外：") .. guid)
                    bucket.invalid = true
                else
                    bucket[resource] = sum
                    sheet.modifiers.count = sheet.modifiers.count + 1
                end
            end
        end
    end
    for guid in pairs(fieldMarkerBindings) do if not seen[guid] then fieldMarkerBindings[guid] = nil end end
end

local function fieldModifiedHearts(sheet, section, hearts, modifiers, keys)
    -- Comprehensive rules v1.06 p.1 [IP]: numeric information may be negative.
    -- Sum signed effects per subject; do not clamp individual markers or totals.
    local result = {}
    for _, key in ipairs(keys) do result[key] = fieldAdjusted(sheet, section, hearts[key] or 0, modifiers[key] or 0) end
    return result
end

local function fieldApplyMarkers(sheet)
    for slot, card in pairs(sheet.stage.slots) do
        local modifiers = sheet.modifiers.member[slot]
        if not modifiers.invalid then
            local effective = {hearts = fieldModifiedHearts(sheet, "stage", card.hearts, modifiers, FIELD_HEART_KEYS),
                blade = fieldAdjusted(sheet, "stage", card.blade, modifiers.blade or 0)}
            for _, key in ipairs(FIELD_HEART_KEYS) do
                sheet.stage.hearts[key] = fieldAdjusted(sheet, "stage", sheet.stage.hearts[key] or 0, modifiers[key] or 0)
            end
            if card.state == "active" then sheet.stage.blade = fieldAdjusted(sheet, "stage", sheet.stage.blade, modifiers.blade or 0) end
            card.effective = effective
        end
    end
    for slot, card in pairs(sheet.live.slots) do
        local modifiers = sheet.modifiers.live[slot]
        if not modifiers.invalid then
            local effective = {hearts = fieldModifiedHearts(sheet, "live", card.hearts, modifiers, FIELD_HEART_KEYS),
                score = fieldAdjusted(sheet, "live", card.score, modifiers.score or 0)}
            for _, key in ipairs(FIELD_HEART_KEYS) do
                sheet.live.hearts[key] = fieldAdjusted(sheet, "live", sheet.live.hearts[key] or 0, modifiers[key] or 0)
            end
            sheet.live.score = fieldAdjusted(sheet, "live", sheet.live.score, modifiers.score or 0)
            card.effective = effective
        end
    end
    if not sheet.modifiers.score.invalid then
        sheet.live.score = fieldAdjusted(sheet, "live", sheet.live.score, sheet.modifiers.score.score or 0)
    end
    local cheer = sheet.modifiers.cheer
    if not cheer.invalid then
        for _, resource in ipairs(MARKER_RESOURCES) do
            local key = resource.key
            local target = key == "all" and "b_all" or key == "heart0" and "b_heart07" or "b_" .. key
            if key == "score" then sheet.cheer.score = fieldAdjusted(sheet, "cheer", sheet.cheer.score, cheer.score or 0)
            elseif key ~= "blade" then
                sheet.cheer.hearts[target] = fieldAdjusted(sheet, "cheer", sheet.cheer.hearts[target] or 0, cheer[key] or 0)
            end
        end
    end
end

-- A card physically beneath the chosen member is attached, not another member.
-- Equal-height or non-overlapping candidates remain ambiguous rather than being summed.
local function fieldUnder(lower, upper)
    if upper.object.getPosition().y - lower.object.getPosition().y < 0.008 then return false end
    local relative = upper.object.positionToLocal(lower.object.getPosition())
    local size, scale = upper.object.getBoundsNormalized().size, upper.object.getScale()
    return math.abs(relative.x) < size.x / scale.x * 0.5 - 0.04
        and math.abs(relative.z) < size.z / scale.z * 0.5 - 0.04
end

local function fieldClaim(sheet, section, guid)
    local owner = fieldOwners[guid]
    if owner and owner ~= sheet.color then
        if section then fieldIssue(sheet, section, tr("他プレイヤーのカード：") .. guid) end
        return false
    end
    fieldOwners[guid] = sheet.color
    return true
end

local function fieldSetText(id, value)
    if fieldText[id] ~= value then
        fieldText[id] = value
        UI.setAttribute(id, "text", value)
    end
end

local function fieldJudgeLive(sheet)
    local function pending(reason)
        return {status = "pending", message = tr("未判定\n") .. reason}
    end
    if fieldBlocked[sheet.color] then return {status = "blocked", message = tr("ライブ不可\n効果による禁止を手動指定")} end
    if sheet.live.hidden > 0 or sheet.cheer.hidden > 0 then return pending(tr("未公開カードがあります")) end
    if not sheet.complete.stage or not sheet.complete.live or not sheet.complete.cheer then
        return pending(tr("カード数値・配置を確認"))
    end
    if sheet.live.count == 0 then return pending(tr("Liveカードを置いてください")) end
    -- Negative modifiers are already applied. Negative resulting requirements
    -- need a rules ruling for icon allocation, not an invented clamp to zero.
    for _, card in pairs(sheet.live.slots) do
        for _, value in pairs(card.effective.hearts) do
            if value < 0 then return pending(tr("負の必要ハートを確認")) end
        end
    end
    local all = sheet.cheer.hearts.b_all or 0
    local neutral = fieldExactSum(sheet.stage.hearts.heart0 or 0, sheet.cheer.hearts.b_heart07 or 0)
    local neutralNeed = sheet.live.hearts.heart0 or 0
    if not neutral then return pending(tr("ハート合計が整数範囲外")) end
    if all < 0 or neutral < 0 then return pending(tr("負の所有ハートを確認")) end
    local availableTotal, requiredTotal = fieldExactSum(all, neutral), neutralNeed
    if not availableTotal then return pending(tr("ハート合計が整数範囲外")) end
    local deficits, available, missing = {}, {}, 0
    for _, heart in ipairs(HEARTS) do
        local key = "heart" .. heart[1]
        local amount = fieldExactSum(sheet.stage.hearts[key] or 0, sheet.cheer.hearts["b_" .. key] or 0)
        local needed = sheet.live.hearts[key] or 0
        if not amount then return pending(tr("ハート合計が整数範囲外")) end
        if amount < 0 then return pending(tr("負の所有ハートを確認")) end
        available[key] = amount
        deficits[key] = math.max(0, needed - amount)
        missing = fieldExactSum(missing, deficits[key])
        availableTotal = fieldExactSum(availableTotal, amount)
        requiredTotal = fieldExactSum(requiredTotal, needed)
        if not missing or not availableTotal or not requiredTotal then return pending(tr("ハート合計が整数範囲外")) end
    end
    -- One shared pool for ALL Live cards. ALL fills colored deficits once;
    -- neutral hearts only contribute to total quantity, never colored deficits.
    local colorShortfall = math.max(0, missing - all)
    local totalShortfall = math.max(0, requiredTotal - availableTotal)
    local success = colorShortfall == 0 and totalShortfall == 0
    return {status = success and "success" or "failure", available = available,
        neutral = neutral, all = all, all_used = math.min(missing, all), deficits = deficits,
        total_available = availableTotal, total_required = requiredTotal,
        color_shortfall = colorShortfall, total_shortfall = totalShortfall,
        message = success and (tr("ライブ成功（現在値）\nハート ") .. availableTotal .. tr(" / 必要 ") .. requiredTotal)
            or (tr("ライブ失敗\n色不足 ") .. colorShortfall .. tr(" / 総数不足 ") .. totalShortfall)}
end

local function fieldHeartRows(values, prefix, last)
    local parts = {}
    for _, heart in ipairs(HEARTS) do table.insert(parts, tr(heart[2]) .. " " .. (values[prefix .. heart[1]] or 0)) end
    return table.concat(parts, "　", 1, 3) .. "\n" .. table.concat(parts, "　", 4, 6)
        .. (last and ("\n" .. last) or "")
end

local function fieldRender(sheet)
    local prefix = "lc_field_" .. sheet.color .. "_"
    local function title(section, text)
        return text .. (sheet.complete[section] and "" or tr(" ［要確認］"))
    end
    fieldSetText(prefix .. "stage", title("stage", tr("ステージ  ") .. sheet.stage.count .. tr(" 人")) .. "\n"
        .. fieldHeartRows(sheet.stage.hearts, "heart") .. tr("\nブレード ") .. sheet.stage.blade
        .. tr("　Active ") .. sheet.stage.active .. tr(" / Wait ") .. sheet.stage.wait)
    fieldSetText(prefix .. "live", title("live", tr("ライブ  公開 ") .. sheet.live.count .. tr(" / 裏 ") .. sheet.live.hidden)
        .. "\n" .. fieldHeartRows(sheet.live.hearts, "heart")
        .. tr("\n無指定 ") .. (sheet.live.hearts.heart0 or 0) .. tr("　スコア ") .. sheet.live.score)
    fieldSetText(prefix .. "cheer", title("cheer", tr("エール  公開 ") .. sheet.cheer.count .. tr(" / 裏 ") .. sheet.cheer.hidden)
        .. "\n" .. fieldHeartRows(sheet.cheer.hearts, "b_heart")
        .. tr("\n無色 ") .. (sheet.cheer.hearts.b_heart07 or 0) .. "　ALL " .. (sheet.cheer.hearts.b_all or 0)
        .. tr("　加点 ") .. sheet.cheer.score .. tr("　ドロー ") .. sheet.cheer.draw)
    fieldSetText(prefix .. "energy", title("energy", tr("エネルギー")) .. tr("\nActive ") .. sheet.energy.active
        .. tr("　Wait ") .. sheet.energy.wait .. tr("　合計 ") .. sheet.energy.total
        .. (sheet.energy.unknown > 0 and (tr("　不明 ") .. sheet.energy.unknown) or ""))
    fieldSetText(prefix .. "judgement", sheet.judgement.message)
    local resultColor = sheet.judgement.status == "success" and "#94E5AB"
        or sheet.judgement.status == "failure" and "#FFAAAA" or "#FFD58A"
    if fieldText[prefix .. "result_color"] ~= resultColor then
        fieldText[prefix .. "result_color"] = resultColor
        UI.setAttribute(prefix .. "judgement", "color", resultColor)
    end
    local blocked = fieldBlocked[sheet.color] and "true" or "false"
    if fieldText[prefix .. "blocked"] ~= blocked then
        fieldText[prefix .. "blocked"] = blocked
        UI.setAttribute(prefix .. "blocked", "isOn", blocked)
    end
    local issues = {}
    for i = 1, math.min(3, #sheet.issues) do issues[i] = sheet.issues[i] end
    if #sheet.issues > 3 then table.insert(issues, tr("ほか ") .. (#sheet.issues - 3) .. tr(" 件（詳細ボタン）")) end
    fieldSetText(prefix .. "issues", #issues == 0 and (tr("配置を自動更新中　補正 ") .. sheet.modifiers.count .. tr(" 件"))
        or table.concat(issues, "\n"))
end

local function fieldCalculate()
    local sheets, instances, seenCache, managed = {}, {}, {}, {}
    local objects = getObjects()
    for _, player in ipairs(fieldConfig.players) do
        local sheet, groups = fieldSheet(player), {stage = {{}, {}, {}}, live = {{}, {}, {}}, cheer = {}, energy = {}}
        table.insert(sheets, sheet)
        local mat = getObjectFromGUID(player.mat)
        if not mat then
            for _, section in ipairs({"stage", "live", "cheer", "energy"}) do fieldIssue(sheet, section, tr("プレイマットがありません：") .. player.mat) end
        else
            local function addRecord(object, section, slot, guid, memo, hidden, child)
                local record = {object = object, section = section, slot = slot, guid = guid,
                    memo = memo, hidden = hidden, child = child, sheet = sheet, mat = mat}
                if slot then table.insert(groups[section][slot], record) else table.insert(groups[section], record) end
                if not hidden then
                    record.card = fieldCard(guid, memo)
                    seenCache[guid] = true
                    if record.card then
                        local id = record.card.instance_id
                        instances[id] = instances[id] or {}
                        table.insert(instances[id], record)
                    end
                end
            end
            for _, object in ipairs(objects) do
                if object.type == "Card" or object.type == "Deck" then
                    local section, slot = fieldRegion(mat.positionToLocal(object.getPosition()))
                    if section then
                        local counted = groups[section] ~= nil
                        if object.held_by_color then
                            if counted then fieldIssue(sheet, section, tr("カード移動中")) end
                        elseif object.type == "Deck" then
                            if section == "stage" or section == "live" or section == "energy" then
                                fieldIssue(sheet, section, tr("この領域は単独カードで配置：") .. object.getGUID())
                            elseif section == "cheer" then
                                local deckMemo = object.memo or ""
                                local ok, meta = pcall(decodeJSON, deckMemo)
                                if ok and type(meta) == "table" and meta.schema == "loveca.deck" then
                                    fieldIssue(sheet, section, tr("牌庫をエールに置かないでください：") .. object.getGUID())
                                else
                                    -- getObjects() has Memo but no transforms in the live TTS API.
                                    -- ContainedObjects preserves each card's recorded face orientation.
                                    for _, child in ipairs(object.getData().ContainedObjects or {}) do
                                        -- The container and each contained card must both be face up.
                                        local t = child.Transform
                                        local hidden = object.is_face_down or not t
                                            or math.cos(math.rad(t.rotX or 0)) * math.cos(math.rad(t.rotZ or 0)) < 0.94
                                        addRecord(object, section, nil, child.GUID, child.Memo, hidden, true)
                                    end
                                end
                            else
                                for _, child in ipairs(object.getObjects()) do fieldClaim(sheet, nil, child.guid) end
                            end
                        elseif counted then
                            addRecord(object, section, slot, object.getGUID(), object.memo, object.is_face_down, false)
                            if section == "stage" or section == "live" or section == "energy" then
                                local guid = object.getGUID()
                                managed[guid] = true
                                if not fieldSticky[guid] then fieldSticky[guid] = {object = object, sticky = object.sticky} end
                                object.sticky = false
                            end
                        else
                            fieldClaim(sheet, nil, object.getGUID())
                        end
                    end
                end
            end
        end
        sheet.groups = groups
    end
    -- Reject all copies of a repeated instance, including duplicates across players.
    for _, entries in pairs(instances) do
        if #entries > 1 then
            for _, entry in ipairs(entries) do
                entry.duplicate = true
                fieldIssue(entry.sheet, entry.section, tr("個体番号が重複：") .. entry.guid)
            end
        end
    end
    local function usable(record, expected)
        local sheet, section = record.sheet, record.section
        if record.hidden then fieldIssue(sheet, section, tr("未公開カードがあります")); return false end
        if record.duplicate then return false end
        if not record.card then fieldIssue(sheet, section, tr("カードデータを確認：") .. record.guid); return false end
        if expected and record.card.type ~= expected then fieldIssue(sheet, section, tr("領域とカード種類が不一致：") .. record.guid); return false end
        if not fieldClaim(sheet, section, record.guid) then return false end
        return true
    end
    for _, sheet in ipairs(sheets) do
        local groups = sheet.groups
        for slot, candidates in ipairs(groups.stage) do
            -- Only one top card may represent the deployed member.
            table.sort(candidates, function(a, b) return a.object.getPosition().y > b.object.getPosition().y end)
            local top, ambiguous = candidates[1], false
            if top then
                for i = 2, #candidates do
                    if not fieldUnder(candidates[i], top) then ambiguous = true end
                end
                if ambiguous then fieldIssue(sheet, "stage", tr(FIELD_SLOT_NAMES[slot]) .. tr("メンバーの重なりを確認"))
                elseif usable(top, "メンバー") then
                    local ok, hearts, blade = pcall(function()
                        return fieldMap(top.card.current.base_heart, FIELD_HEART_KEYS), fieldNumber(top.card.current.blade)
                    end)
                    if not ok then fieldIssue(sheet, "stage", tr("メンバー数値を確認：") .. top.guid)
                    else
                        local state = fieldState(top.object, top.mat)
                        fieldAdd(sheet.stage.hearts, hearts)
                        sheet.stage.count = sheet.stage.count + 1
                        sheet.stage.slots[slot] = {guid = top.guid, instance_id = top.card.instance_id,
                            state = state, attached = #candidates - 1, hearts = hearts, blade = blade}
                        if state == "unknown" then fieldIssue(sheet, "stage", tr(FIELD_SLOT_NAMES[slot]) .. tr("メンバーの向きが不明"))
                        else
                            sheet.stage[state] = sheet.stage[state] + 1
                            if state == "active" then sheet.stage.blade = sheet.stage.blade + blade end
                        end
                    end
                end
            end
        end
        for slot, candidates in ipairs(groups.live) do
            for _, record in ipairs(candidates) do if record.hidden then sheet.live.hidden = sheet.live.hidden + 1 end end
            if #candidates > 1 then fieldIssue(sheet, "live", tr(FIELD_SLOT_NAMES[slot]) .. tr("Live は 1 枚ずつ配置"))
            elseif #candidates == 1 and usable(candidates[1], "ライブ") then
                local record = candidates[1]
                local ok, hearts, score = pcall(function()
                    return fieldMap(record.card.current.need_heart, FIELD_HEART_KEYS), fieldNumber(record.card.current.score)
                end)
                if not ok then fieldIssue(sheet, "live", tr("Live 数値を確認：") .. record.guid)
                else
                    fieldAdd(sheet.live.hearts, hearts)
                    sheet.live.score, sheet.live.count = sheet.live.score + score, sheet.live.count + 1
                    sheet.live.slots[slot] = {guid = record.guid, instance_id = record.card.instance_id,
                        hearts = hearts, score = score}
                end
            end
        end
        for _, record in ipairs(groups.cheer) do
            if record.hidden then sheet.cheer.hidden = sheet.cheer.hidden + 1 end
            if usable(record) then
                local ok, hearts, score, draw = pcall(function()
                    if record.card.type ~= "メンバー" and record.card.type ~= "ライブ" then error(tr("エール種類")) end
                    local current = record.card.current
                    if type(current.special_heart) ~= "table" then error(tr("特殊ハート")) end
                    return fieldMap(current.blade_heart, FIELD_CHEER_KEYS),
                        fieldNumber(current.special_heart.score == nil and 0 or current.special_heart.score),
                        fieldNumber(current.special_heart.draw == nil and 0 or current.special_heart.draw)
                end)
                if not ok then fieldIssue(sheet, "cheer", tr("エール数値を確認：") .. record.guid)
                else
                    fieldAdd(sheet.cheer.hearts, hearts)
                    sheet.cheer.count = sheet.cheer.count + 1
                    sheet.cheer.score, sheet.cheer.draw = sheet.cheer.score + score, sheet.cheer.draw + draw
                end
            end
        end
        for _, record in ipairs(groups.energy) do
            if usable(record, "エネルギー") then
                local state = fieldState(record.object, record.mat)
                sheet.energy.total = sheet.energy.total + 1
                sheet.energy[state] = sheet.energy[state] + 1
                if state == "unknown" then fieldIssue(sheet, "energy", tr("エネルギーの向きが不明：") .. record.guid) end
            end
        end
        sheet.groups = nil
    end
    fieldCollectMarkers(sheets)
    for _, sheet in ipairs(sheets) do
        fieldApplyMarkers(sheet)
        sheet.judgement = fieldJudgeLive(sheet)
        sheet.issueSet = nil
    end
    for guid, entry in pairs(fieldSticky) do
        if not managed[guid] then
            if entry.object and not entry.object.isDestroyed() then entry.object.sticky = entry.sticky end
            fieldSticky[guid] = nil
        end
    end
    for guid in pairs(fieldCache) do if not seenCache[guid] then fieldCache[guid] = nil end end
    return sheets
end

function refreshLovecaField()
    local ok, sheets = pcall(fieldCalculate)
    if not ok then
        local message = tostring(sheets)
        -- Replace stale numbers with explicit incomplete results after a scanner error.
        sheets = {}
        for _, player in ipairs(fieldConfig.players) do
            local sheet = fieldSheet(player)
            for _, section in ipairs({"stage", "live", "cheer", "energy"}) do fieldIssue(sheet, section, tr("集計エラー（詳細はログ）")) end
            sheet.judgement = {status = "pending", message = tr("未判定\n集計エラー（詳細はログ）")}
            table.insert(sheets, sheet)
        end
        if fieldText.error ~= message then print("[LoveCa Field] " .. message); fieldText.error = message end
    else
        fieldText.error = nil
    end
    fieldSnapshot = sheets
    if not UI.loading then
        for _, sheet in ipairs(sheets) do fieldRender(sheet) end
        fieldSetText("lc_field_initiative_result", initiativeText)
    end
    return copy(sheets)
end

function getLovecaFieldSnapshot()
    return copy(fieldSnapshot)
end

function openLovecaField()
    showLovecaPanel("field")
    refreshLovecaField()
end

function closeLovecaField()
    closeLovecaPanel("field")
end

function lovecaFieldDetails(player)
    for _, sheet in ipairs(fieldSnapshot) do
        local message = colorName(sheet.color) .. ": " .. sheet.judgement.message
            .. (#sheet.issues == 0 and "" or ("\n" .. table.concat(sheet.issues, "\n")))
        if sheet.judgement.deficits then
            message = message .. tr("\n色別不足（ALL充当前） ") .. fieldHeartRows(sheet.judgement.deficits, "heart")
                .. tr("\nALL充当 ") .. sheet.judgement.all_used .. tr(" / 所有 ") .. sheet.judgement.all
        end
        if player then printToColor(message, player.color, {1, 0.85, 0.5}) else print(message) end
    end
end

local function initiativeResult(color)
    return string.format(tr("[%sプレイヤー]が\n先攻・後攻を決定"), colorName(color))
end

function drawLovecaInitiative(player)
    local colors = {}
    for _, color in ipairs(getSeatedPlayers()) do
        -- GM and spectator are roles represented by Black/Grey seats. A host
        -- seated at a normal player color is still eligible; admin is irrelevant.
        if color ~= "Black" and color ~= "Grey" then table.insert(colors, color) end
    end
    if #colors == 0 then
        initiativeWinner, initiativeText = nil, tr("抽選待ち\nプレイヤーが未着席")
        fieldSetText("lc_field_initiative_result", initiativeText)
        if player then printToColor(tr("GM・観戦者以外のプレイヤーが着席してから抽選してください。"), player.color, {1, .85, .5}) end
        return nil
    end
    -- Use the engine's existing PRNG; never reseed on each click.
    initiativeWinner = colors[math.random(#colors)]
    initiativeText = initiativeResult(initiativeWinner)
    fieldSetText("lc_field_initiative_result", initiativeText)
    broadcastToAll("[LoveCa] " .. string.gsub(initiativeText, "\n", " "), {1, .85, .5})
    return initiativeWinner
end

function lovecaFieldBlockedChanged(player, value, id)
    local color = string.match(id or "", "^lc_field_(%w+)_blocked$")
    for _, configured in ipairs(fieldConfig.players) do
        if color == configured.color then
            fieldBlocked[color] = value == true or value == "True" or value == "true"
            refreshLovecaField()
            return
        end
    end
end

local function fieldNode(tag, attributes, children)
    return {tag = tag, attributes = attributes, children = children}
end

local function fieldUI()
    local children = {
        fieldNode("Text", {text = tr("LoveCa 盤面計算"), fontSize = "22", color = "#FFFFFF", width = "400", height = "36",
            alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "20 -10"}),
        fieldNode("Button", {text = tr("更新"), onClick = "refreshLovecaField", fontSize = "17", width = "75", height = "32",
            rectAlignment = "UpperRight", offsetXY = "-155 -12", color = "#40557A", textColor = "#FFFFFF"}),
        fieldNode("Button", {text = tr("詳細"), onClick = "lovecaFieldDetails", fontSize = "17", width = "75", height = "32",
            rectAlignment = "UpperRight", offsetXY = "-72 -12", color = "#40557A", textColor = "#FFFFFF"}),
        fieldNode("Button", {text = "×", onClick = "closeLovecaField", fontSize = "24", width = "34", height = "34",
            rectAlignment = "UpperRight", offsetXY = "-16 -10", color = "#40557A", textColor = "#FFFFFF"})
    }
    for i, player in ipairs(fieldConfig.players) do
        local column = {fieldNode("Text", {text = colorName(player.color), fontSize = "21", color = i == 1 and "#FFFFFF" or "#FFABC9",
            width = "310", height = "30", alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "12 -8"})}
        for _, row in ipairs({{"stage", 46, 112}, {"live", 170, 112}, {"cheer", 294, 112},
            {"judgement", 418, 76}, {"energy", 540, 62}, {"issues", 612, 72}}) do
            table.insert(column, fieldNode("Text", {id = "lc_field_" .. player.color .. "_" .. row[1], text = tr("読込中…"),
                fontSize = row[1] == "issues" and "16" or "18", color = row[1] == "issues" and "#FFD58A" or "#EFF3FF",
                width = "332", height = tostring(row[3]), alignment = "UpperLeft", rectAlignment = "UpperLeft",
                offsetXY = "12 -" .. row[2]}))
        end
        table.insert(column, fieldNode("Toggle", {id = "lc_field_" .. player.color .. "_blocked",
            text = tr("Live不可（効果・手動）"), onValueChanged = "lovecaFieldBlockedChanged",
            isOn = fieldBlocked[player.color] and "true" or "false", width = "332", height = "26", fontSize = "17",
            textColor = "#EFF3FF", rectAlignment = "UpperLeft", offsetXY = "12 -502",
            tooltip = tr("禁止効果は手動で反映してください。ハート判定は現在の入力値で自動更新します。")}))
        table.insert(children, fieldNode("Panel", {width = "356", height = "696", color = "#303B4E",
            rectAlignment = "UpperLeft", offsetXY = (i == 1 and "16" or "388") .. " -56"}, column))
    end
    return {
        fieldNode("Button", {id = "lc_field_launcher", onClick = "openLovecaField", text = tr("盤面計算"), width = "160",
            height = "44", rectAlignment = "UpperLeft", offsetXY = "80 -134", fontSize = "18", color = "#38594F", textColor = "#FFFFFF"}),
        fieldNode("Panel", {id = "lc_field_panel", width = "760", height = "770", color = "#202735F5",
            rectAlignment = "UpperLeft", offsetXY = LOVECA_PANEL_OFFSET, allowDragging = "true", active = "false"}, children),
        fieldNode("Button", {id = "lc_field_initiative", onClick = "drawLovecaInitiative", text = tr("先攻・後攻を決定"),
            width = "160", height = "44", rectAlignment = "UpperLeft", offsetXY = "80 -242", fontSize = "18",
            color = "#66513D", textColor = "#FFFFFF", tooltip = tr("GM・観戦者を除き、着席者から先攻／後攻を選ぶ人をランダム抽選")}),
        fieldNode("Text", {id = "lc_field_initiative_result", text = initiativeText,
            width = "160", height = "58", rectAlignment = "UpperLeft", offsetXY = "80 -296", fontSize = "15",
            color = "#FFD58A", alignment = "UpperLeft"})
    }
end

local function fieldOutline(mat)
    local lines = mat.getVectorLines() or {}
    -- Match the complete outline, not just its first point, to preserve unrelated lines.
    local kept = {}
    local r = FIELD_CHEER
    local expected = {{r.left, r.top}, {r.right, r.top}, {r.right, r.bottom}, {r.left, r.bottom}, {r.left, r.top}}
    for _, line in ipairs(lines) do
        local ours = line.points and #line.points == #expected
        if ours then
            for i, point in ipairs(line.points) do
                if math.abs((point.x or point[1] or 0) - expected[i][1]) > 0.0001
                    or math.abs((point.z or point[3] or 0) - expected[i][2]) > 0.0001 then ours = false end
            end
        end
        if not ours then table.insert(kept, line) end
    end
    table.insert(kept, {points = {{r.left, 0.115, r.top}, {r.right, 0.115, r.top},
        {r.right, 0.115, r.bottom}, {r.left, 0.115, r.bottom}, {r.left, 0.115, r.top}},
        color = {0.25, 0.65, 0.55}, thickness = 0.025, rotation = {0, 0, 0}})
    mat.setVectorLines(kept)
    for _, button in ipairs(mat.getButtons() or {}) do
        if button.click_function == "openLovecaField" then mat.removeButton(button.index) end
    end
    mat.createButton({click_function = "openLovecaField", function_owner = Global, label = tr("エール"),
        position = {-2.44, 0.13, -0.90}, rotation = {0, 0, 0}, width = 0, height = 0,
        font_size = 70, font_color = {0.2, 0.45, 0.38}})
end

local function fieldSave()
    local sticky = {}
    for guid, entry in pairs(fieldSticky) do sticky[guid] = entry.sticky end
    return {version = 1, config = copy(fieldConfig), owners = copy(fieldOwners), sticky = sticky,
        marker_bindings = copy(fieldMarkerBindings), blocked = copy(fieldBlocked), initiative = initiativeWinner}
end

local function fieldLoad(state)
    if type(state) == "table" and state.version == 1 then
        if type(state.config) == "table" and type(state.config.players) == "table" then fieldConfig = copy(state.config) end
        if type(state.owners) == "table" then fieldOwners = copy(state.owners) end
        if type(state.marker_bindings) == "table" then fieldMarkerBindings = copy(state.marker_bindings) end
        for _, player in ipairs(fieldConfig.players) do
            fieldBlocked[player.color] = type(state.blocked) == "table" and state.blocked[player.color] == true
        end
        if type(state.initiative) == "string" and state.initiative ~= "Black" and state.initiative ~= "Grey" then
            initiativeWinner = state.initiative
            initiativeText = initiativeResult(initiativeWinner)
        end
        for guid, sticky in pairs(state.sticky or {}) do
            local object = getObjectFromGUID(guid)
            if object then fieldSticky[guid] = {object = object, sticky = sticky} end
        end
    end
    if LovecaFieldTimer then Wait.stop(LovecaFieldTimer) end
    fieldText = {}
    for _, player in ipairs(fieldConfig.players) do
        local mat = getObjectFromGUID(player.mat)
        if mat then fieldOutline(mat) end
    end
    Wait.frames(refreshLovecaField, 3)
    -- Polling also covers physics and programmatic moves that player events miss.
    LovecaFieldTimer = Wait.time(refreshLovecaField, 1, -1)
end

local function refreshFieldLanguage()
    fieldText = {}
    if initiativeWinner then initiativeText = initiativeResult(initiativeWinner)
    elseif initiativeText ~= "" then initiativeText = tr("抽選待ち\nプレイヤーが未着席") end
    for _, player in ipairs(fieldConfig.players) do
        local mat = getObjectFromGUID(player.mat)
        if mat then fieldOutline(mat) end
    end
end

function tryObjectEnterContainer(container, object)
    if isLovecaMarker(container) or isLovecaMarker(object) then return false end
    if not object or (object.type ~= "Card" and object.type ~= "Deck") then return true end
    for _, player in ipairs(fieldConfig.players) do
        local mat = getObjectFromGUID(player.mat)
        if mat then
            for _, candidate in ipairs({container, object}) do
                local section = fieldRegion(mat.positionToLocal(candidate.getPosition()))
                if section == "stage" or section == "live" or section == "energy" then return false end
            end
        end
    end
    return true
end
