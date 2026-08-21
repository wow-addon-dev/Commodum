local addonName, COM = ...

local version = C_AddOns.GetAddOnMetadata(addonName, "Version") or ""
local buildDate = C_AddOns.GetAddOnMetadata(addonName, "X-BuildDate") or ""

COM.CHANGELOG = {
	{
		version = version,
		date = buildDate ~= "" and buildDate or nil,
		entries = {
			"Changed: General loot notifications can now be hidden separately for items, money, and personal currencies",
			"Changed: Quality-of-life options are now organized into expandable sections",
			"Changed: Option names were shortened"
		}
	},
	{
		version = "v1.19",
		date = "2026-08-18",
		entries = {
			"Added: Changelog window available from the options menu",
			"Added: Changelog window available through the 'changelog' slash command",
			"Removed: Version notice chat messages",
			"Adapted to the latest version of Arcane Wizard: Library to ensure full compatibility"
		}
	},
	{
		version = "v1.18",
		date = "2026-08-14",
		entries = {
			"Removed: TOC version for patch 12.0.7 [retail]"
		}
	},
	{
		version = "v1.17",
		date = "2026-08-04",
		entries = {
			"Minor code adjustments"
		}
	},
	{
		version = "v1.16",
		date = "2026-08-01",
		entries = {
			"Added: Damaged items can now be repaired automatically with personal funds when a repair merchant window opens"
		}
	},
	{
		version = "v1.15",
		date = "2026-07-28",
		entries = {
			"Added: General loot notifications for items, money, and personal currencies can now be hidden",
			"Minor code adjustments",
			"Adapted to the latest version of Arcane Wizard: Library to ensure full compatibility"
		}
	},
	{
		version = "v1.14",
		date = "2026-07-26",
		entries = {
			"Minor code adjustments"
		}
	},
	{
		version = "v1.13",
		date = "2026-07-21",
		entries = {
			"Refactoring of the addon structure and source code"
		}
	},
	{
		version = "v1.12",
		date = "2026-07-19",
		entries = {
			"Added: Automatically sells all copies of items marked per character and, optionally, all poor-quality items when a merchant window opens"
		}
	},
	{
		version = "v1.11",
		date = "2026-07-18",
		entries = {
			"Minor code adjustments"
		}
	}
}
