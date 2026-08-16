local addonName, COM = ...

local version = C_AddOns.GetAddOnMetadata(addonName, "Version") or ""
local buildDate = C_AddOns.GetAddOnMetadata(addonName, "X-BuildDate") or ""
local currentVersion = version

if buildDate ~= "" then
	currentVersion = currentVersion .. " (" .. buildDate .. ")"
end

COM.CHANGELOG_TEXT = table.concat({
	"|cffffd200" .. currentVersion .. "|r\n\n"
		.. "- Added: Changelog window available from the options menu\n"
		.. "- Removed: Version notice chat messages\n"
		.. "- Adapted to the latest version of Arcane Wizard: Library to ensure full compatibility",
	"|cffffd200v1.18 (2026-08-14)|r\n\n"
		.. "- Removed: TOC version for patch 12.0.7 [retail]",
	"|cffffd200v1.17 (2026-08-04)|r\n\n"
		.. "- Minor code adjustments",
	"|cffffd200v1.16 (2026-08-01)|r\n\n"
		.. "- Added: Damaged items can now be repaired automatically with personal funds when a repair merchant window opens",
	"|cffffd200v1.15 (2026-07-28)|r\n\n"
		.. "- Added: General loot notifications for items, money, and personal currencies can now be hidden\n"
		.. "- Minor code adjustments\n"
		.. "- Adapted to the latest version of Arcane Wizard: Library to ensure full compatibility"
}, "\n\n")
