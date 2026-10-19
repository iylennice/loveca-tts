-- Adjustable marker creation and placement. Field calculation owns numeric effects.
local markerForm = {color = "White", resource = "heart01", value = "+1", target = "storage"}
local markerPanel = nil
local markerSnapshot = {}
-- Member lanes sit to each card's right (owner-facing local X decreases).
-- Live lanes sit in the gap between Live and member cards, never between mats.
local markerTargets = {
    {key = "member1", scope = "member", slot = 1, label = "メンバー 左", short = "M1", x = .397, z = -.03, w = .11, d = .60, cols = 1, rows = 4},
    {key = "member2", scope = "member", slot = 2, label = "メンバー 中", short = "M2", x = -.32, z = -.03, w = .11, d = .60, cols = 1, rows = 4},
    {key = "member3", scope = "member", slot = 3, label = "メンバー 右", short = "M3", x = -1.08, z = -.03, w = .11, d = .60, cols = 1, rows = 4},
    {key = "live1", scope = "live", slot = 1, label = "Live 左", short = "L1", x = .695, z = -.41, w = .64, d = .16, cellOffsetZ = -.025, cols = 4, rows = 1},
    {key = "live2", scope = "live", slot = 2, label = "Live 中", short = "L2", x = -.011, z = -.41, w = .64, d = .16, cellOffsetZ = -.025, cols = 4, rows = 1},
    {key = "live3", scope = "live", slot = 3, label = "Live 右", short = "L3", x = -.698, z = -.41, w = .64, d = .16, cellOffsetZ = -.025, cols = 4, rows = 1},
    {key = "storage", scope = "storage", label = "保管（無効）", x = -2.75, z = .45, w = .85, d = .70, cols = 5, rows = 4},
    {key = "score", scope = "score", label = "Live 合計 S", x = 1.55, z = -.72, w = .44, d = .32, cols = 3, rows = 2},
    {key = "cheer", scope = "cheer", label = "エール補正", x = 2.44, z = 1.05, w = 1.0, d = .24, cols = 6, rows = 1}
}
-- Remove exactly the prototype's old outlines when migrating a saved table.
local markerLegacyAreas = {
    {x = 1.16, z = -.03, w = .11, d = .60},
    {x = .695, z = -.41, w = .64, d = .13}, {x = -.011, z = -.41, w = .64, d = .13},
    {x = -.698, z = -.41, w = .64, d = .13},
    {x = .780, z = 1.82, w = .70, d = .35}, {x = .017, z = 1.82, w = .70, d = .35},
    {x = -.700, z = 1.82, w = .70, d = .35}, {x = .780, z = 1.34, w = .70, d = .35},
    {x = .017, z = 1.34, w = .70, d = .35}, {x = -.700, z = 1.34, w = .70, d = .35},
    {x = -2.45, z = .55, w = 1.10, d = .74}, {x = 1.44, z = 1.34, w = .48, d = .35},
    {x = 2.44, z = 1.34, w = 1.0, d = .35}
}

local function markerNode(tag, attributes, children)
    return {tag = tag, attributes = attributes, children = children}
end

local function markerTarget(key)
    for _, target in ipairs(markerTargets) do if target.key == key then return target end end
end

local function markerPlayers()
    local players = {}
    for _, sheet in ipairs(getLovecaFieldSnapshot()) do table.insert(players, {color = sheet.color, mat = sheet.mat}) end
    return players
end

local function markerPlayer(color)
    for _, player in ipairs(markerPlayers()) do if player.color == color then return player end end
end

local function markerCompatible(scope, resource)
    if type(resource) ~= "string" or not markerDefinition(resource) then return false end
    if scope == "storage" then return true end
    if scope == "score" then return resource == "score" end
    if scope == "member" then return resource == "blade" or string.match(resource, "^heart0[1-6]$") ~= nil end
    if scope == "live" then return resource == "score" or resource == "heart0" or string.match(resource, "^heart0[1-6]$") ~= nil end
    if scope == "cheer" then return resource ~= "blade" end
    return false
end

function isLovecaMarker(object)
    if not object or not object.memo or object.memo == "" then return false end
    -- Avoid decoding large card metadata in the container guard.
    if not string.find(object.memo, "loveca.marker", 1, true) then return false end
    local ok, data = pcall(JSON.decode, object.memo)
    return ok and type(data) == "table" and data.schema == "loveca.marker" and data.schema_version == 1
end

function showLovecaPanel(mode)
    markerPanel = mode
    for _, name in ipairs({"import", "field", "marker", "locale"}) do
        local panel = "lc_" .. name .. "_panel"
        if mode == name then
            UI.setAttribute(panel, "offsetXY", LOVECA_PANEL_OFFSET)
            UI.show(panel)
        else
            UI.hide(panel)
        end
        UI.show("lc_" .. name .. "_launcher")
    end
end

function closeLovecaPanel(mode)
    if markerPanel == mode then showLovecaPanel(nil) end
end

local function markerStatus(text)
    UI.setAttribute("lc_marker_status", "text", text)
end

local function markerFormRender()
    if UI.loading then return end
    for _, definition in ipairs(MARKER_RESOURCES) do
        UI.setAttribute("lc_marker_resource_" .. definition.key, "color", markerForm.resource == definition.key and "#54789B" or "#35445B")
    end
    for _, target in ipairs(markerTargets) do
        UI.setAttribute("lc_marker_target_" .. target.key, "color", markerForm.target == target.key and "#54789B" or "#35445B")
    end
    for _, color in ipairs({tr("White"), tr("Pink")}) do
        UI.setAttribute("lc_marker_player_" .. color, "color", markerForm.color == color and "#54789B" or "#35445B")
    end
    UI.setAttribute("lc_marker_value", "text", markerForm.value)
end

function openLovecaMarkers(player)
    if player and markerPlayer(player.color) then markerForm.color = player.color end
    showLovecaPanel("marker")
    markerFormRender()
end

function closeLovecaMarkers()
    closeLovecaPanel("marker")
end

function selectLovecaMarkerResource(player, value, id)
    local key = string.match(id, "^lc_marker_resource_(.+)$")
    if markerDefinition(key) then markerForm.resource = key; markerFormRender() end
end

function selectLovecaMarkerTarget(player, value, id)
    local key = string.match(id, "^lc_marker_target_(.+)$")
    if markerTarget(key) then markerForm.target = key; markerFormRender() end
end

function selectLovecaMarkerPlayer(player, value, id)
    local color = string.match(id, "^lc_marker_player_(.+)$")
    if markerPlayer(color) then markerForm.color = color; markerFormRender() end
end

function lovecaMarkerValueChanged(player, value)
    markerForm.value = value
end

local function markerInteger(text)
    if type(text) ~= "string" or not string.match(text, "^[%+%-]?%d+$") then return nil end
    local value = tonumber(text)
    if not value or value ~= math.floor(value) or math.abs(value) > 9007199254740991 then return nil end
    return value
end

function stepLovecaMarkerValue(player, value, id)
    local current = markerInteger(markerForm.value)
    if not current then markerStatus(tr("符号付き整数を入力してください。例：+2、-1")); return end
    markerForm.value = string.format("%+d", current + (id == "lc_marker_minus" and -1 or 1))
    markerFormRender()
end

local function markerCells(mat, target)
    local positions = {}
    for row = 1, target.rows do
        for col = 1, target.cols do
            table.insert(positions, mat.positionToWorld({x = target.x + (col - (target.cols + 1) / 2) * .16,
                y = .32, z = target.z + (target.cellOffsetZ or 0) + (row - (target.rows + 1) / 2) * .15}))
        end
    end
    return positions
end

local function markerVacant(mat, target)
    local mats, occupied = {}, {}
    for _, player in ipairs(markerPlayers()) do mats[player.mat] = true end
    for _, object in ipairs(getObjects()) do
        if not mats[object.getGUID()] and object.type ~= "Hand" then
            table.insert(occupied, {position = object.getPosition(), size = object.getBounds().size})
        end
    end
    for _, position in ipairs(markerCells(mat, target)) do
        local free = true
        for _, entry in ipairs(occupied) do
            if math.abs(entry.position.x - position.x) < entry.size.x / 2 + .30
                and math.abs(entry.position.z - position.z) < entry.size.z / 2 + .30 then free = false; break end
        end
        if free then return position end
    end
end

function createLovecaMarker(player, value, id)
    local definition, target = markerDefinition(markerForm.resource), markerTarget(markerForm.target)
    local number, owner = markerInteger(markerForm.value), markerPlayer(markerForm.color)
    if number == nil then markerStatus(tr("符号付き整数を入力してください。例：+2、-1")); return end
    if not definition or not target or not owner then markerStatus(tr("種類・配置先・プレイヤーを確認してください。")); return end
    if not markerCompatible(target.scope, definition.key) then
        markerStatus(string.format(tr("%s は %s の対象外です。"), tr(target.label), tr(definition.name)))
        return
    end
    local mat = getObjectFromGUID(owner.mat)
    if not mat then markerStatus(tr("プレイマットがありません。")); return end
    local position = markerVacant(mat, target)
    if not position then markerStatus(tr("配置先が埋まっています。マーカーやカードを移動してください。")); return end
    local data = {Name = "Custom_Tile", Memo = JSON.encode({schema = "loveca.marker", schema_version = 1,
        resource = definition.key, value = number}), LuaScript = MARKER_OBJECT_SCRIPT, LuaScriptState = "",
        CustomImage = {ImageURL = definition.image, ImageSecondaryURL = definition.image,
            ImageScalar = 1, WidthScale = 0,
            CustomTile = {Type = 2, Thickness = .20, Stackable = false, Stretch = true}},
        Transform = {posX = position.x, posY = position.y, posZ = position.z, rotX = 0,
            rotY = mat.getRotation().y, rotZ = 0, scaleX = .28, scaleY = .50, scaleZ = .28},
        ColorDiffuse = {r = 1, g = 1, b = 1, a = 1},
        Locked = false, Grid = false, Snap = false, Sticky = false, Hands = false,
        HideWhenFaceDown = false, Tooltip = true, DragSelectable = true}
    local ok, object = pcall(spawnObjectData, {data = data})
    if not ok then markerStatus(tr("作成できませんでした：") .. tostring(object)); return end
    markerStatus(tr(definition.name) .. " " .. string.format("%+d", number) .. " → " .. colorName(owner.color) .. " / " .. tr(target.label))
    return object.getGUID()
end

local function markerPlacement(object, players)
    local matches = {}
    for _, player in ipairs(players) do
        local mat = getObjectFromGUID(player.mat)
        if mat then
            local p = mat.positionToLocal(object.getPosition())
            if p.y >= -.15 and p.y <= 1.3 then
                for _, target in ipairs(markerTargets) do
                    if math.abs(p.x - target.x) <= target.w / 2 and math.abs(p.z - target.z) <= target.d / 2 then
                        table.insert(matches, {color = player.color, scope = target.scope, slot = target.slot, code = "placed"})
                    end
                end
            end
        end
    end
    local placement = #matches == 1 and matches[1]
        or {code = #matches == 0 and "unassigned" or "ambiguous", matches = matches}
    if object.held_by_color or object.resting == false then placement.code = "moving" end
    return placement
end

function refreshLovecaMarkers(players)
    -- UI callbacks pass a player object, not this internal configuration list.
    if type(players) ~= "table" or not players[1] then players = markerPlayers() end
    local snapshot, instances = {}, {}
    for _, object in ipairs(getObjects()) do
        if isLovecaMarker(object) then
            local data = JSON.decode(object.memo)
            local placement = markerPlacement(object, players)
            local valid = markerDefinition(data.resource) and type(data.value) == "number"
                and data.value == data.value and math.abs(data.value) <= 9007199254740991
                and data.value == math.floor(data.value)
                and type(data.instance_id) == "string" and data.instance_id ~= ""
            if not valid then placement.code = "invalid_data"
            elseif placement.code == "placed" and not markerCompatible(placement.scope, data.resource) then
                placement.code = "wrong_resource"
            end
            local entry = {guid = object.getGUID(), instance_id = data.instance_id,
                resource = data.resource, value = data.value, placement = placement}
            table.insert(snapshot, entry)
            if valid then
                instances[data.instance_id] = instances[data.instance_id] or {}
                table.insert(instances[data.instance_id], entry)
            end
        end
    end
    for _, entries in pairs(instances) do
        if #entries > 1 then
            for _, entry in ipairs(entries) do entry.placement.code = "duplicate" end
        end
    end
    for _, entry in ipairs(snapshot) do
        local object = getObjectFromGUID(entry.guid)
        if object and object.getLuaScript() == MARKER_OBJECT_SCRIPT then
            object.call("setMarkerPlacement", entry.placement)
        end
    end
    markerSnapshot = snapshot
    return snapshot
end

function getLovecaMarkerSnapshot()
    return markerSnapshot
end

function saveLovecaMarkers()
    return {version = 1, form = {color = markerForm.color, resource = markerForm.resource,
        value = markerForm.value, target = markerForm.target}}
end

function lovecaMarkerUI()
    local children = {
        markerNode("Text", {text = tr("数値マーカー"), fontSize = "22", color = "#FFFFFF", width = "380", height = "35",
            alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "20 -10"}),
        markerNode("Button", {text = "×", onClick = "closeLovecaMarkers", width = "34", height = "34", fontSize = "24",
            rectAlignment = "UpperRight", offsetXY = "-12 -8", color = "#3A4560", textColor = "#FFFFFF"})
    }
    for i, color in ipairs({tr("White"), tr("Pink")}) do
        table.insert(children, markerNode("Button", {id = "lc_marker_player_" .. color, text = colorName(color), onClick = "selectLovecaMarkerPlayer",
            width = "100", height = "34", fontSize = "18", textColor = "#FFFFFF", color = "#35445B",
            rectAlignment = "UpperLeft", offsetXY = (20 + (i - 1) * 112) .. " -58"}))
    end
    for i, definition in ipairs(MARKER_RESOURCES) do
        table.insert(children, markerNode("Button", {id = "lc_marker_resource_" .. definition.key,
            text = tr(definition.short), tooltip = tr(definition.name), onClick = "selectLovecaMarkerResource",
            width = "78", height = "38", fontSize = "18", textColor = "#FFFFFF", color = "#35445B",
            rectAlignment = "UpperLeft", offsetXY = (20 + (i - 1) % 5 * 87) .. " -" .. (112 + math.floor((i - 1) / 5) * 46)}))
    end
    table.insert(children, markerNode("Text", {text = tr("初期値"), width = "80", height = "34", fontSize = "18", color = "#FFFFFF",
        rectAlignment = "UpperLeft", offsetXY = "20 -218"}))
    table.insert(children, markerNode("InputField", {id = "lc_marker_value", text = markerForm.value,
        onValueChanged = "lovecaMarkerValueChanged", width = "140", height = "36", fontSize = "21", textColor = "#182233",
        rectAlignment = "UpperLeft", offsetXY = "104 -216"}))
    for i, item in ipairs({{"minus", "−1"}, {"plus", "+1"}}) do
        table.insert(children, markerNode("Button", {id = "lc_marker_" .. item[1], text = item[2], onClick = "stepLovecaMarkerValue",
            width = "72", height = "36", fontSize = "18", textColor = "#FFFFFF", color = "#35445B",
            rectAlignment = "UpperLeft", offsetXY = (262 + (i - 1) * 83) .. " -216"}))
    end
    table.insert(children, markerNode("Text", {text = tr("配置先"), width = "180", height = "28", fontSize = "18", color = "#FFFFFF",
        alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "20 -272"}))
    for i, target in ipairs(markerTargets) do
        table.insert(children, markerNode("Button", {id = "lc_marker_target_" .. target.key, text = tr(target.label),
            onClick = "selectLovecaMarkerTarget", width = "136", height = "36", fontSize = "16", color = "#35445B", textColor = "#FFFFFF",
            rectAlignment = "UpperLeft", offsetXY = (20 + (i - 1) % 3 * 144) .. " -" .. (308 + math.floor((i - 1) / 3) * 44)}))
    end
    table.insert(children, markerNode("Button", {text = tr("マーカー作成"), onClick = "createLovecaMarker", width = "260", height = "40",
        fontSize = "20", color = "#3C655A", textColor = "#FFFFFF", rectAlignment = "UpperCenter", offsetXY = "0 -452"}))
    table.insert(children, markerNode("Text", {id = "lc_marker_status", text = tr("必要なマーカーだけ作成できます。"), width = "430", height = "54",
        fontSize = "16", color = "#FFD58A", alignment = "UpperLeft", rectAlignment = "UpperLeft", offsetXY = "20 -510"}))
    table.insert(children, markerNode("Text", {text = tr("図柄を移動、外側の数値：左 +1 ／ 右 −1\n補正欄に置くと盤面計算に反映（保管は無効）\n交代時は保管へ戻し、新しい対象の欄に置き直す"), width = "430", height = "76",
        fontSize = "17", color = "#D5DDEA", alignment = "UpperLeft", rectAlignment = "UpperLeft", offsetXY = "20 -574"}))
    return {
        markerNode("Button", {id = "lc_marker_launcher", text = tr("数値マーカー"), onClick = "openLovecaMarkers", width = "160", height = "44",
            rectAlignment = "UpperLeft", offsetXY = "80 -188", fontSize = "18", color = "#675438", textColor = "#FFFFFF"}),
        markerNode("Panel", {id = "lc_marker_panel", width = "470", height = "666", rectAlignment = "UpperLeft", offsetXY = LOVECA_PANEL_OFFSET,
            color = "#202735F5", allowDragging = "true", active = "false"}, children)
    }
end

local function markerDrawAreas()
    for _, player in ipairs(markerPlayers()) do
        local mat = getObjectFromGUID(player.mat)
        if mat then
            local kept = {}
            for _, line in ipairs(mat.getVectorLines() or {}) do
                local first = line.points and line.points[1]
                local ours = false
                if first and line.points and #line.points == 5 then
                    local areas = {}
                    for _, area in ipairs(markerTargets) do table.insert(areas, area) end
                    for _, area in ipairs(markerLegacyAreas) do table.insert(areas, area) end
                    for _, target in ipairs(areas) do
                        local x, z, w, d = target.x, target.z, target.w / 2, target.d / 2
                        local corners = {{x - w, z - d}, {x + w, z - d}, {x + w, z + d}, {x - w, z + d}, {x - w, z - d}}
                        local matches = true
                        for i, point in ipairs(line.points) do
                            if math.abs((point.x or point[1] or 0) - corners[i][1]) > .0001
                                or math.abs((point.z or point[3] or 0) - corners[i][2]) > .0001 then matches = false end
                        end
                        if matches then ours = true end
                    end
                end
                if not ours then table.insert(kept, line) end
            end
            local buttons = mat.getButtons() or {}
            -- Remove in reverse order to keep native indices valid.
            for i = #buttons, 1, -1 do
                if buttons[i].click_function == "openLovecaMarkers" then mat.removeButton(buttons[i].index) end
            end
            for _, target in ipairs(markerTargets) do
                local x, z, w, d = target.x, target.z, target.w / 2, target.d / 2
                local color = target.scope == "member" and {.35, .48, .72}
                    or target.scope == "live" and {.72, .47, .25} or {.35, .57, .50}
                table.insert(kept, {points = {{x - w, .125, z - d}, {x + w, .125, z - d},
                    {x + w, .125, z + d}, {x - w, .125, z + d}, {x - w, .125, z - d}},
                    color = color, thickness = .012, rotation = {0, 0, 0}})
                local labelX, labelZ = x, z + d + .06
                -- Center the label inside its own Live frame, between the two
                -- middle value badges. Do not place it beside the next frame.
                if target.scope == "live" then labelX, labelZ = x, z + d - .025 end
                mat.createButton({click_function = "openLovecaMarkers", function_owner = Global,
                    label = tr(target.short or target.label), tooltip = tr(target.label),
                    -- TTS button canvases mirror local X versus vector lines.
                    -- Verified on both mats: negate X only, keep local Z.
                    position = {-labelX, .14, labelZ}, rotation = {0, 0, 0}, width = 0, height = 0,
                    font_size = target.short and 30 or 38, font_color = {.12, .20, .30}})
            end
            mat.setVectorLines(kept)
        end
    end
end

local function refreshMarkerLanguage()
    markerDrawAreas()
    markerFormRender()
    for _, object in ipairs(getObjects()) do
        if isLovecaMarker(object) and object.getLuaScript() == MARKER_OBJECT_SCRIPT then
            object.call("setMarkerLanguage", {language = LANGUAGE})
        end
    end
end

function initializeLovecaMarkers(state)
    if state and state.version == 1 and type(state.form) == "table" then
        local form = state.form
        if markerDefinition(form.resource) then markerForm.resource = form.resource end
        if markerTarget(form.target) then markerForm.target = form.target end
        if type(form.value) == "string" then markerForm.value = form.value end
        if form.color == "White" or form.color == "Pink" then markerForm.color = form.color end
    end
    if LovecaMarkerTimer then Wait.stop(LovecaMarkerTimer) end
    Wait.frames(function() refreshMarkerLanguage(); refreshLovecaMarkers() end, 5)
    -- The field timer scans cards and markers together; no second stale poll.
end

function installLovecaMarkerUI()
    local active = UI.getAttribute("lc_import_panel", "active") == "true" and "import"
        or UI.getAttribute("lc_field_panel", "active") == "true" and "field"
        or UI.getAttribute("lc_marker_panel", "active") == "true" and "marker" or nil
    local ui = {}
    for _, node in ipairs(UI.getXmlTable()) do
        if not string.match((node.attributes or {}).id or "", "^lc_marker_") then table.insert(ui, node) end
    end
    for _, node in ipairs(lovecaMarkerUI()) do table.insert(ui, node) end
    UI.setXmlTable(ui)
    Wait.frames(function() showLovecaPanel(active); markerFormRender() end, 5)
end
