local addonname, COM = ...

if GetLocale() ~= "deDE" then return end

local L = COM.Localization

-- Options

L["options.general"] = "Allgemeine Einstellungen"
L["options.general.notification.name"] = "Chatbenachrichtigung"
L["options.general.notification.tooltip"] = "Aktiviere oder deaktiviere die Benachrichtung im Chat."
L["options.general.minimap-button.name"] = "Minimap Button"
L["options.general.minimap-button.tooltip"] = "Bei Aktivierung wird der Minimap Button angezeigt."

L["options.quality-of-life"] = "Quality of Life"
L["options.quality-of-life.military-time.name"] = "military-time"
L["options.quality-of-life.military-time.tooltip"] = "military-time"
L["options.quality-of-life.watched-faction.name"] = "watched-faction"
L["options.quality-of-life.watched-faction.tooltip"] = "watched-faction"

L["options.other"] = "Sonstige Einstellungen"
L["options.other.debug-mode.name"] = "Debugmodus"
L["options.other.debug-mode.tooltip"] = "Die Aktivierung des Debugmodus zeigt zusätzliche Informationen im Chat an."

L["options.about"] = "Über"
L["options.about.game-version"] = "Spielversion"
L["options.about.addon-version"] = "Addonversion"
L["options.about.author"] = "Autor"

L["options.about.button-delete-data.name"] = "???"
L["options.about.button-delete-data.tooltip"] = "???"
L["options.about.button-delete-data.button"] = "???"

L["options.about.button-github.name"] = "Feedback & Hilfe"
L["options.about.button-github.tooltip"] = "Öffnet ein Popup-Fenster mit einem Link nach GitHub."
L["options.about.button-github.button"] = "GitHub"

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Rechtsklick|r zum Öffnen der Einstellungen."

-- Dialog

L["dialog.copy-address.text"] = "Um den Link zu kopieren drücke STRG + C."
L["dialog.delete-data.text"] = "Sollen alle Addon Daten wirklich gelöscht werden?\n|cnNORMAL_FONT_COLOR:Achtung:|r Es erfolgt ein automatischer Reload der Spieloberfläche!"
