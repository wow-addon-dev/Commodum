local _, COM = ...

if GetLocale() ~= "deDE" then return end

local L = COM.Localization

-- Options

L["options.general"] = "Allgemeine Einstellungen"
L["options.general.minimap-button.name"] = "Minimap-Button"
L["options.general.minimap-button.tooltip"] = "Bei Aktivierung wird der Minimap-Button angezeigt."
L["options.general.debug-mode.name"] = "Debugmodus"
L["options.general.debug-mode.tooltip"] = "Die Aktivierung des Debugmodus zeigt zusätzliche Informationen im Chat an."

L["options.quality-of-life"] = "Komfortfunktionen"
L["options.quality-of-life.military-time.name"] = "24-Stunden-Uhr verwenden"
L["options.quality-of-life.military-time.tooltip"] = "Verwendet die 24-Stunden-Anzeige für die Spielzeituhr."
L["options.quality-of-life.watched-faction.name"] = "Ruffraktion automatisch beobachten"
L["options.quality-of-life.watched-faction.tooltip"] = "Setzt die Fraktion, deren Ruf sich geändert hat, automatisch als beobachtete Fraktion."

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Rechtsklick|r zum Öffnen der Einstellungen."

-- Chat

-- Quality of Life
