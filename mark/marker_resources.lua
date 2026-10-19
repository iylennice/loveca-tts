-- Shared by Global and standalone markers. Visuals reuse the existing table's
-- circular Custom_Tile assets, inspected on 2026-10-19; originals stay untouched.
local MARKER_RESOURCES = {
    {key = "heart01", name = "桃ハート", short = "桃♥", body = {1, .80, .89}, ink = {.58, .06, .28}},
    {key = "heart02", name = "赤ハート", short = "赤♥", body = {1, .79, .76}, ink = {.64, .08, .04}},
    {key = "heart03", name = "黄ハート", short = "黄♥", body = {1, .94, .60}, ink = {.46, .30, .02}},
    {key = "heart04", name = "緑ハート", short = "緑♥", body = {.72, .94, .76}, ink = {.05, .38, .17}},
    {key = "heart05", name = "青ハート", short = "青♥", body = {.69, .88, 1}, ink = {.03, .30, .53}},
    {key = "heart06", name = "紫ハート", short = "紫♥", body = {.87, .77, .98}, ink = {.38, .12, .58}},
    {key = "heart0", name = "無色／無指定ハート", short = "無♥", body = {.91, .92, .94}, ink = {.25, .28, .35}},
    {key = "all", name = "ALLハート", short = "ALL♥", body = {1, .86, .96}, ink = {.56, .08, .44}},
    {key = "blade", name = "ブレード", short = "B", body = {.72, .88, .97}, ink = {.08, .28, .43}},
    {key = "score", name = "スコア", short = "S", body = {1, .88, .61}, ink = {.48, .28, .03}}
}

local MARKER_ASSET_ROOT = "https://steamusercontent-a.akamaihd.net/ugc/"
local MARKER_IMAGES = {
    heart01 = "27692883760551143/E6A0F26BAF08D054F679C42E719E2806064F4580/", -- 58e089
    heart02 = "27692883760545449/77F8B562BDCA71A9D563D68D99349150540DAEB9/", -- 137858
    heart03 = "27692883760543848/92C3F93CDF07665F12B7504978CB0378786C6071/", -- 013095
    heart04 = "27692883760549385/583C7E129E1367A7408EBCBD5A2AB0D7169600E7/", -- 96cdf3
    heart05 = "27692883760550184/4617E265C3A3C3EB78C40C82DE5D71BA8312685B/", -- 12afee
    heart06 = "27692883760529876/48C4B9F40E745EFCCA632482D44A779A5740389B/", -- 384cf6
    heart0 = "27692883760548302/4E38F6364D80FAD6F443A8FED31D570F38BDCE39/", -- c8c282
    all = "27692883760546326/83CA850BB9C6F6CDA4C93819341EB34361B065EB/", -- 186e6c
    blade = "27692883750484188/98D46E0E83471E6586F631087D917FA000CF7A58/", -- ef63ee
    score = "27692883750489229/04A3283304E3ABC61BE754B199575B36063A2E36/" -- 266a7a
}
for _, definition in ipairs(MARKER_RESOURCES) do
    definition.image = MARKER_ASSET_ROOT .. MARKER_IMAGES[definition.key]
end

local function markerDefinition(key)
    for _, definition in ipairs(MARKER_RESOURCES) do
        if definition.key == key then return definition end
    end
end
