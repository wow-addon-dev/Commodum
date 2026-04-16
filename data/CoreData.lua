local addonName, COM = ...

COM.ADDON_AUTHOR = C_AddOns.GetAddOnMetadata(addonName, "Author")
COM.ADDON_VERSION = C_AddOns.GetAddOnMetadata(addonName, "Version")
COM.ADDON_BUILD_DATE = C_AddOns.GetAddOnMetadata(addonName, "X-BuildDate")

COM.GAME_VERSION = GetBuildInfo()

COM.LINK_GITHUB = C_AddOns.GetAddOnMetadata(addonName, "X-Github")
COM.LINK_CURSEFORGE = C_AddOns.GetAddOnMetadata(addonName, "X-Curseforge")

COM.MEDIA_PATH = "Interface\\AddOns\\" .. addonName .. "\\assets\\"

COM.GAME_TYPE_VANILLA = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
COM.GAME_TYPE_TBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
---@diagnostic disable-next-line: undefined-global
COM.GAME_TYPE_MISTS = (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC)
COM.GAME_TYPE_MAINLINE = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

COM.GAME_FLAVOR = "unknown"

if COM.GAME_TYPE_VANILLA then
	COM.GAME_FLAVOR = "Classic"
elseif COM.GAME_TYPE_TBC then
	COM.GAME_FLAVOR = "Burning Crusade - Classic Anniversary Edition"
elseif COM.GAME_TYPE_MISTS then
	COM.GAME_FLAVOR = "Mist of Pandaria - Classic"
elseif COM.GAME_TYPE_MAINLINE then
	COM.GAME_FLAVOR = "Retail"
end
