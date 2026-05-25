local _, COM = ...

COM.Localization = setmetatable({}, {__index=function(self,key)
	geterrorhandler()("Commodum (Debug): Missing entry for '" .. tostring(key) .. "'")
	return key
end})

local L = COM.Localization

-- Options

L["options.general"] = "General Options"
L["options.general.minimap-button.name"] = "Minimap Button"
L["options.general.minimap-button.tooltip"] = "When this is enabled, the minimap button is displayed."
L["options.general.debug-mode.name"] = "Debug Mode"
L["options.general.debug-mode.tooltip"] = "Enabling the debug mode displays additional information in the chat."

L["options.quality-of-life"] = "Quality of Life"
L["options.quality-of-life.military-time.name"] = "Use 24-Hour Clock"
L["options.quality-of-life.military-time.tooltip"] = "Uses the 24-hour clock for the in-game time display."
L["options.quality-of-life.watched-faction.name"] = "Auto-Watch Reputation"
L["options.quality-of-life.watched-faction.tooltip"] = "Automatically sets the faction whose reputation changed as the watched faction."

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Right-click|r to open the options."

-- Chat

-- Quality of Life
