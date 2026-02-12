ZONESRANGE = {
    [ALAHTHALAS] = { 1, 10 },
    [ALTERACMOUNTAINS] = { 30, 40 },
    [ARATHIHIGHLANDS] = { 30, 40 },
    [ASHENVALE] = { 18, 30 },
    [AZSHARA] = { 45, 55 },
    [BADLANDS] = { 35, 45 },
    [BALOR] = { 29, 34 },
    [BLACKSTONEISLAND] = { 1, 10 },
    [BLASTEDLANDS] = { 45, 55 },
    [BURNINGSTEPPES] = { 50, 58 },
    [DARKSHORE] = { 10, 20 },
    [DARNASSUS] = { 1, 10 },
    [DEADWINDPASS] = { 55, 60 },
    [DESOLACE] = { 30, 40 },
    [DUNMOROGH] = { 1, 10 },
    [DUROTAR] = { 1, 10 },
    [DUSKWOOD] = { 18, 30 },
    [DUSTWALLOWMARSH] = { 35, 45 },
    [EASTERNPLAGUELANDS] = { 53, 60 },
    [ELWYNNFOREST] = { 1, 10 },
    [FELWOOD] = { 48, 55 },
    [FERALAS] = { 40, 50 },
    [GILLIJIMSISLE] = { 48, 53 },
    [GILNEAS] = { 39, 46 },
    [GRIMREACHES] = { 33, 38 },
    [HILLSBRADFOOTHILLS] = { 20, 30 },
    [HYJAL] = { 58, 60 },
    [IRONFORGE] = { 1, 10 },
    [LAPIDISISLE] = { 48, 53 },
    [LOCHMODAN] = { 10, 20 },
    [MOONGLADE] = { 1, 60 },
    [MULGORE] = { 1, 10 },
    [NORTHWIND] = { 28, 34 },
    [ORGRIMMAR] = { 1, 10 },
    [REDRIDGEMOUNTAINS] = { 15, 25 },
    [SCARLETENCLAVE] = { 55, 60 },
    [SEARINGGORGE] = { 43, 50 },
    [SILITHUS] = { 55, 60 },
    [SILVERPINEFOREST] = { 10, 20 },
    [STONETALONMOUNTAINS] = { 15, 27 },
    [STORMWINDCITY] = { 1, 10 },
    [STRANGLETHORNVALE] = { 30, 45 },
    [SWAMPOFSORROWS] = { 35, 45 },
    [TANARIS] = { 40, 50 },
    [TELABIM] = { 54, 60 },
    [TELDRASSIL] = { 1, 10 },
    [THALASSIANHIGHLANDS] = { 1, 10 },
    [THEBARRENS] = { 10, 25 },
    [THEHINTERLANDS] = { 40, 50 },
    [THOUSANDNEEDLES] = { 25, 35 },
    [THUNDERBLUFF] = { 1, 10 },
    [TIRISFALGLADES] = { 1, 10 },
    [UNDERCITY] = { 1, 10 },
    [UNGOROCRATER] = { 48, 55 },
    [WESTERNPLAGUELANDS] = { 51, 58 },
    [WESTFALL] = { 10, 20 },
    [WETLANDS] = { 20, 30 },
    [WINTERSPRING] = { 55, 60 },
};

CITIES = {
    [ALAHTHALAS] = true,
    [DARNASSUS] = true,
    [IRONFORGE] = true,
    [ORGRIMMAR] = true,
    [STORMWINDCITY] = true,
    [THUNDERBLUFF] = true,
    [UNDERCITY] = true,
}

COLORS = {
    Gray = { 0.50, 0.50, 0.50, },
    Green = { 0.25, 0.74, 0.25, },
    Yellow = { 1.0, 1.0, 0.0, },
    Orange = { 1.0, 0.50, 0.25, },
    Red = { 0.86, 0.13, 0.13, },
};

local originalOnUpdate = function() end;

function LibLocPlus:GetZoneColor(playerLevel, zoneMin, zoneMax)
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
        return;
    end

    if not zoneName or zoneName == "" then
        WorldMapFrameAreaDescription:SetText("");
        return;
    end

    if zoomed then
        -- Filter out capitals when zoomed. This code SUCKS lol!
        if CITIES[zoneName] then
            WorldMapFrameAreaDescription:SetText("");
            return;
        end
    end

    local displayText = "";

    if ZONESRANGE[zoneName] then
        local min = ZONESRANGE[zoneName][1];
        local max = ZONESRANGE[zoneName][2];
        local playerLevel = UnitLevel("player");
        local color = getZoneColor(playerLevel, min, max);

        displayText = "(" .. min .. "-" .. max .. ")";

        WorldMapFrameAreaDescription:SetTextColor(color[1], color[2], color[3]);
    else
        WorldMapFrameAreaDescription:SetTextColor(1, 1, 1);
    end

    WorldMapFrameAreaDescription:SetText(displayText);
end

function ZonesLevel_WorldMapButton_OnUpdate(arg)
    originalOnUpdate(arg);

    local areaName = WorldMapFrame.areaName or "";
    local zoneNum = GetCurrentMapZone();

    updateZoneNameText(areaName, zoneNum ~= 0);
end

function ZonesLevel_OnLoad()
    originalOnUpdate = WorldMapButton_OnUpdate;
    WorldMapButton_OnUpdate = ZonesLevel_WorldMapButton_OnUpdate;
end
