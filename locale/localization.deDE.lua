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
L["options.quality-of-life.auto-sell.name"] = "Markierte Gegenstände automatisch verkaufen"
L["options.quality-of-life.auto-sell.tooltip"] = "Verkauft alle Exemplare markierter Gegenstände automatisch, sobald ein Händlerfenster geöffnet wird. Gegenstände werden im Inventar mit der ausgewählten Modifikatortaste + Rechtsklick markiert oder ihre Markierung wird entfernt. Die Markierungen werden immer getrennt für jeden Charakter gespeichert."

L["options.auto-sell.marking-modifier.name"] = "Modifikatortaste zum Markieren"
L["options.auto-sell.marking-modifier.tooltip"] = "Legt fest, welche Modifikatortaste zusammen mit einem Rechtsklick Gegenstände markiert oder ihre Markierung entfernt. Alt ist die konfliktärmste Voreinstellung; Strg und Umschalt können zusätzlich Standardaktionen von WoW auslösen."
L["options.auto-sell.poor.name"] = "Graue Gegenstände automatisch verkaufen"
L["options.auto-sell.poor.tooltip"] = "Verkauft alle Gegenstände der Qualitätsstufe Schlecht (grau) automatisch, sobald ein Händlerfenster geöffnet wird. Diese Einstellung funktioniert unabhängig vom Verkauf manuell markierter Gegenstände."

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Rechtsklick|r zum Öffnen der Einstellungen."

-- Chat

L["auto-sell.chat.marked"] = "%s wird künftig automatisch verkauft."
L["auto-sell.chat.unmarked"] = "%s wird nicht mehr automatisch verkauft."
L["auto-sell.chat.cannot-mark"] = "%s kann nicht für den automatischen Verkauf markiert werden, da der Gegenstand keinen Händlerwert besitzt."
L["auto-sell.chat.sold-one"] = "1 Gegenstand wurde automatisch für %s verkauft."
L["auto-sell.chat.sold-many"] = "%d Gegenstände wurden automatisch für %s verkauft."

-- Quality of Life

L["auto-sell.tooltip.marked"] = "Für den automatischen Verkauf markiert. %s + Rechtsklick zum Entfernen."
L["auto-sell.tooltip.unmarked"] = "%s + Rechtsklick: Für den automatischen Verkauf markieren."
L["auto-sell.marking-modifier.alt"] = "Alt"
L["auto-sell.marking-modifier.ctrl"] = "Strg"
L["auto-sell.marking-modifier.shift"] = "Umschalt"
