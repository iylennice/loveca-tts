-- Standalone object script, bundled with marker_resources.lua by the build tool.
-- Memo is the current source of truth. All persistent keys/values are ASCII.
local marker, definition
local placementText = {member = "メンバー", live = "Live", score = "Live 合計", cheer = "エール", storage = "保管"}
local slotText = {"左", "中", "右"}

local function signed(value)
    return string.format("%+d", value)
end

local function integer(value)
    if type(value) == "string" and not string.match(value, "^[%+%-]?%d+$") then return nil end
    value = tonumber(value)
    if not value or value ~= value or value == math.huge or value == -math.huge
        or value ~= math.floor(value) or math.abs(value) > 9007199254740991 then return nil end
    return value
end

local function describe()
    local p = marker.placement or {}
    local scope = tr(placementText[p.scope] or "未配置")
    if p.slot then scope = scope .. " " .. tr(slotText[p.slot] or "?") end
    if p.color then scope = colorName(p.color) .. " / " .. scope end
    if p.code == "wrong_resource" then scope = scope .. tr("（種類が対象外）") end
    if p.code == "moving" then scope = tr("移動中") end
    if p.code == "ambiguous" then scope = tr("領域が重複（補正無効）") end
    if p.code == "invalid_data" or p.code == "duplicate" then scope = scope .. tr("（データ要確認）") end
    self.setName(tr(definition.name) .. " " .. signed(marker.value))
    self.setDescription(scope .. tr("\n図柄をドラッグして移動\n外側の数値：左クリック +1 ／ 右クリック −1\n右クリックメニュー：直接入力・符号反転・0・削除\n補正欄で盤面計算に反映（保管は無効）\n交代時は保管へ戻してから置き直す"))
end

local function persist()
    self.memo = JSON.encode(marker)
    describe()
end

local function render()
    local value = signed(marker.value)
    local font = math.min(140, math.floor(440 / math.max(3, #value)))
    self.setColorTint({1, 1, 1}) -- Keep the supplied art's original colors.
    local button = {label = value,
        font_size = font, font_color = {.08, .10, .15},
        tooltip = tr(definition.name) .. " " .. value .. tr("\n左 +1 ／ 右 −1")}
    if #(self.getButtons() or {}) == 0 then
        button.click_function = "adjustMarker"
        button.function_owner = self
        -- Keep the whole art/collider available for native dragging. Only the
        -- detached value badge handles clicks; nothing overlays the icon.
        button.position = {0, .36, 1.65}
        button.rotation = {0, 0, 0}
        -- TTS scales the button canvas again on small custom tiles.
        -- Compensate so the signed value stays legible without enlarging art.
        local canvasScale = 1 / self.getScale().x
        button.scale = {canvasScale, canvasScale, canvasScale}
        button.width, button.height = 340, 150
        button.color = {1, 1, 1, .97}
        button.hover_color = {1, .94, .76, 1}
        button.press_color = {1, .86, .54, 1}
        self.createButton(button)
    else
        button.index = 0
        self.editButton(button)
    end
    persist()
end

function setMarkerValue(args)
    if not marker then return false end
    local value = integer(args.value)
    if value == nil then
        if args.player then printToColor(tr("符号付き整数を入力してください。"), args.player, {1, .65, .4}) end
        return false
    end
    marker.value = value
    render()
    return true
end

function adjustMarker(object, player_color, alt_click)
    if marker then setMarkerValue({value = marker.value + (alt_click and -1 or 1), player = player_color}) end
end

function getMarkerState()
    return marker and JSON.decode(self.memo) or nil
end

function setMarkerPlacement(info)
    if not marker then return end
    local previous = marker.placement or {}
    if previous.color == info.color and previous.scope == info.scope and previous.slot == info.slot
        and previous.code == info.code then return end
    marker.placement = {color = info.color, scope = info.scope, slot = info.slot, code = info.code}
    persist()
end

function onSave()
    return marker and JSON.encode(marker) or ""
end

local function rebuildMarkerMenu()
    self.clearContextMenu()
    self.addContextMenuItem(tr("数値を入力"), function(color)
        Player[color].showInputDialog(tr(definition.name) .. tr("（符号付き整数）"), signed(marker.value), function(text)
            if not self.isDestroyed() then setMarkerValue({value = text, player = color}) end
        end)
    end)
    self.addContextMenuItem(tr("符号を反転"), function() setMarkerValue({value = -marker.value}) end)
    self.addContextMenuItem(tr("0 に戻す"), function() setMarkerValue({value = 0}) end)
    self.addContextMenuItem(tr("マーカーを削除"), function() self.destruct() end)
end

function setMarkerLanguage(args)
    if not marker or not args or not isLovecaLanguage(args.language) then return end
    LANGUAGE = args.language
    rebuildMarkerMenu()
    render()
end

function onLoad(saved_data)
    local ok, data = pcall(JSON.decode, self.memo ~= "" and self.memo or saved_data or "")
    if not ok or type(data) ~= "table" or data.schema ~= "loveca.marker" or data.schema_version ~= 1 then return end
    definition = markerDefinition(data.resource)
    if not definition or integer(data.value) == nil then return end
    marker = data
    marker.instance_id = "loveca.marker." .. self.getGUID() -- Clones are separate adjustable markers.
    self.sticky, self.use_grid, self.use_snap_points, self.use_hands = false, false, false, false
    self.clearButtons()
    LANGUAGE = Global.getVar("LovecaLanguage") or LANGUAGE
    rebuildMarkerMenu()
    render()
end
