ZONESRANGE = {
    [ZL_ALAHTHALAS] = { 1, 10 },
    [ZL_ALTERACMOUNTAINS] = { 30, 40 },
    [ZL_ARATHIHIGHLANDS] = { 30, 40 },
    [ZL_ASHENVALE] = { 18, 30 },
    [ZL_AZSHARA] = { 45, 55 },
    [ZL_BADLANDS] = { 35, 45 },
    [ZL_BALOR] = { 29, 34 },
    [ZL_BLACKSTONEISLAND] = { 1, 10 },
    [ZL_BLASTEDLANDS] = { 45, 55 },
    [ZL_BURNINGSTEPPES] = { 50, 58 },
    [ZL_DARKSHORE] = { 10, 20 },
    [ZL_DARNASSUS] = { 1, 10 },
    [ZL_DEADWINDPASS] = { 55, 60 },
    [ZL_DESOLACE] = { 30, 40 },
    [ZL_DUNMOROGH] = { 1, 10 },
    [ZL_DUROTAR] = { 1, 10 },
    [ZL_DUSKWOOD] = { 18, 30 },
    [ZL_DUSTWALLOWMARSH] = { 35, 45 },
    [ZL_EASTERNPLAGUELANDS] = { 53, 60 },
    [ZL_ELWYNNFOREST] = { 1, 10 },
    [ZL_FELWOOD] = { 48, 55 },
    [ZL_FERALAS] = { 40, 50 },
    [ZL_GILLIJIMSISLE] = { 48, 53 },
    [ZL_GILNEAS] = { 39, 46 },
    [ZL_GRIMREACHES] = { 33, 38 },
    [ZL_HILLSBRADFOOTHILLS] = { 20, 30 },
    [ZL_HYJAL] = { 58, 60 },
    [ZL_IRONFORGE] = { 1, 10 },
    [ZL_LAPIDISISLE] = { 48, 53 },
    [ZL_LOCHMODAN] = { 10, 20 },
    [ZL_MOONGLADE] = { 1, 60 },
    [ZL_MULGORE] = { 1, 10 },
    [ZL_NORTHWIND] = { 28, 34 },
    [ZL_ORGRIMMAR] = { 1, 10 },
    [ZL_REDRIDGEMOUNTAINS] = { 15, 25 },
    [ZL_SCARLETENCLAVE] = { 55, 60 },
    [ZL_SEARINGGORGE] = { 43, 50 },
    [ZL_SILITHUS] = { 55, 60 },
    [ZL_SILVERPINEFOREST] = { 10, 20 },
    [ZL_STONETALONMOUNTAINS] = { 15, 27 },
    [ZL_STORMWINDCITY] = { 1, 10 },
    [ZL_STRANGLETHORNVALE] = { 30, 45 },
    [ZL_SWAMPOFSORROWS] = { 35, 45 },
    [ZL_TANARIS] = { 40, 50 },
    [ZL_TELABIM] = { 54, 60 },
    [ZL_TELDRASSIL] = { 1, 10 },
    [ZL_THALASSIANHIGHLANDS] = { 1, 10 },
    [ZL_THEBARRENS] = { 10, 25 },
    [ZL_THEHINTERLANDS] = { 40, 50 },
    [ZL_THOUSANDNEEDLES] = { 25, 35 },
    [ZL_THUNDERBLUFF] = { 1, 10 },
    [ZL_TIRISFALGLADES] = { 1, 10 },
    [ZL_UNDERCITY] = { 1, 10 },
    [ZL_UNGOROCRATER] = { 48, 55 },
    [ZL_WESTERNPLAGUELANDS] = { 51, 58 },
    [ZL_WESTFALL] = { 10, 20 },
    [ZL_WETLANDS] = { 20, 30 },
    [ZL_WINTERSPRING] = { 55, 60 },
}

CITIES = {
    [ZL_ALAHTHALAS] = true,
    [ZL_DARNASSUS] = true,
    [ZL_IRONFORGE] = true,
    [ZL_ORGRIMMAR] = true,
    [ZL_STORMWINDCITY] = true,
    [ZL_THUNDERBLUFF] = true,
    [ZL_UNDERCITY] = true,
}

COLORS = {
    Gray = { 0.50, 0.50, 0.50, },
    Green = { 0.25, 0.74, 0.25, },
    Yellow = { 1.0, 1.0, 0.0, },
    Orange = { 1.0, 0.50, 0.25, },
    Red = { 0.86, 0.13, 0.13, },
}

local originalOnUpdate = function() end

local function getZoneColor(playerLevel, zoneMin, zoneMax)
    local averageLevel = floor((zoneMax - zoneMin) / 2) + zoneMin
    local levelDiff = averageLevel - playerLevel
    local color

    if levelDiff > 4 then
        color = COLORS.Red
    elseif levelDiff > 2 then
        color = COLORS.Orange
    elseif levelDiff > -3 then
        color = COLORS.Yellow
    elseif levelDiff > -12 then
        color = COLORS.Green
    else
        color = COLORS.Gray
    end

    if zoneMin == zoneMax then
        color = COLORS.Orange
    end

    return color
end

local function updateZoneNameText(zoneName, zoomed)
    if not WorldMapFrameAreaDescription then
        return
    end

    if not zoneName or zoneName == "" then
        WorldMapFrameAreaDescription:SetText("")
        return
    end

    if zoomed then
        -- Filter out capitals when zoomed. This code SUCKS lol!
        if CITIES[zoneName] then
            WorldMapFrameAreaDescription:SetText("")
            return
        end
    end

    local displayText = ""

    if ZONESRANGE[zoneName] then
        local min = ZONESRANGE[zoneName][1]
        local max = ZONESRANGE[zoneName][2]
        local playerLevel = UnitLevel("player")
        local color = getZoneColor(playerLevel, min, max)

        displayText = "(" .. min .. "-" .. max .. ")"

        WorldMapFrameAreaDescription:SetTextColor(color[1], color[2], color[3])
    else
        WorldMapFrameAreaDescription:SetTextColor(1, 1, 1)
    end

    WorldMapFrameAreaDescription:SetText(displayText)
end

function ZonesLevel_WorldMapButton_OnUpdate(arg)
    originalOnUpdate(arg)

    local areaName = WorldMapFrame.areaName or ""
    local zoneNum = GetCurrentMapZone()

    updateZoneNameText(areaName, zoneNum ~= 0)
end

function ZonesLevel_OnLoad()
    originalOnUpdate = WorldMapButton_OnUpdate
    WorldMapButton_OnUpdate = ZonesLevel_WorldMapButton_OnUpdate
end
