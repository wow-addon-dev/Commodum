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
L["options.quality-of-life.hide-loot-toasts.name"] = "Hide General Loot Toasts"
L["options.quality-of-life.hide-loot-toasts.tooltip"] = "Hides general loot notifications for items, money, and personal currencies."
L["options.quality-of-life.auto-repair.name"] = "Automatically Repair Items"
L["options.quality-of-life.auto-repair.tooltip"] = "Automatically repairs damaged items using personal funds when a repair merchant window opens."
L["options.quality-of-life.auto-sell.name"] = "Automatically Sell Marked Items"
L["options.quality-of-life.auto-sell.tooltip"] = "Automatically sells every copy of marked items when a merchant window opens. Use the selected modifier key and right-click items in your bags to mark or unmark them. Item markings are always saved separately for each character."

L["options.auto-sell.marking-modifier.name"] = "Marking Modifier Key"
L["options.auto-sell.marking-modifier.tooltip"] = "Selects the modifier key that marks or unmarks items when used with a right-click. Alt is the least conflicting default; Ctrl and Shift may also trigger standard World of Warcraft actions."
L["options.auto-sell.poor.name"] = "Automatically Sell Poor-Quality Items"
L["options.auto-sell.poor.tooltip"] = "Automatically sells every poor-quality (gray) item when a merchant window opens. This setting works independently from selling manually marked items."

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Right-click|r to open the options."

-- Chat

L["auto-repair.chat.repaired"] = "Automatically repaired all items for %s."
L["auto-repair.chat.insufficient-funds"] = "Items could not be repaired automatically because there is not enough money."
L["auto-sell.chat.marked"] = "%s will now be sold automatically."
L["auto-sell.chat.unmarked"] = "%s will no longer be sold automatically."
L["auto-sell.chat.cannot-mark"] = "%s cannot be marked for automatic selling because the item has no vendor value."
L["auto-sell.chat.sold-one"] = "Automatically sold 1 item for %s."
L["auto-sell.chat.sold-many"] = "Automatically sold %d items for %s."

-- Quality of Life

L["auto-sell.tooltip.marked"] = "Marked for automatic selling. %s + right-click to remove."
L["auto-sell.tooltip.unmarked"] = "%s + right-click: Mark for automatic selling."
L["auto-sell.marking-modifier.alt"] = "Alt"
L["auto-sell.marking-modifier.ctrl"] = "Ctrl"
L["auto-sell.marking-modifier.shift"] = "Shift"
