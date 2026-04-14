local addonname, COM = ...

COM.Localization = setmetatable({},{__index=function(self,key)
    geterrorhandler()("Horatum (Debug): Missing entry for '" .. tostring(key) .. "'")
    return key
end})

local L = COM.Localization

-- Options

L["options.general"] = "General Options"
L["options.general.notification.name"] = "Chat Notification"
L["options.general.notification.tooltip"] = "Activate or deactivate the notification in the chat."
L["options.general.minimap-button.name"] = "Minimap Button"
L["options.general.minimap-button.tooltip"] = "When this is enabled, the minimap button is displayed."

L["options.quality-of-life"] = "Quality of Life"
L["options.quality-of-life.military-time.name"] = "military-time"
L["options.quality-of-life.military-time.tooltip"] = "military-time"
L["options.quality-of-life.watched-faction.name"] = "watched-faction"
L["options.quality-of-life.watched-faction.tooltip"] = "watched-faction"

L["options.other"] = "Other Options"
L["options.other.debug-mode.name"] = "Debug Mode"
L["options.other.debug-mode.tooltip"] = "Enabling the debug mode displays additional information in the chat."

L["options.about"] = "About"
L["options.about.game-version"] = "Game Version"
L["options.about.addon-version"] = "Addon Version"
L["options.about.author"] = "Author"

L["options.about.button-delete-data.name"] = "???"
L["options.about.button-delete-data.tooltip"] = "???"
L["options.about.button-delete-data.button"] = "???"

L["options.about.button-github.name"] = "Feedback & Help"
L["options.about.button-github.tooltip"] = "Opens a popup window with a link to GitHub."
L["options.about.button-github.button"] = "GitHub"

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Right-click|r to open the options."
