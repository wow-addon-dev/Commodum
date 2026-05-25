local addonName, COM = ...

local Options = COM.modules.Options
local Utils = COM.modules.Utils

--------------
--- Frames ---
--------------

local CommodumFrame = CreateFrame("Frame", "Commodum")

-----------------------
--- Local Functions ---
-----------------------

local function SlashCommand(msg, editbox)
	if not msg or strtrim(msg) == "" then
		if not InCombatLockdown() then
			Settings.OpenToCategory(COM.MAIN_CATEGORY_ID)
		else
			Utils:PrintDebug("In combat. The options menu cannot be opened.")
		end
	else
		Utils:PrintDebug("These arguments are not accepted.")
	end
end

------------------------
--- Public Functions ---
------------------------

function CommodumFrame:OnEvent(event, ...)
	self[event](self, event, ...)
end

function CommodumFrame:ADDON_LOADED(_, addOnName)
	if addOnName == addonName then
		Utils:InitializeDatabase()
		Utils:InitializeMinimapButton()
		Options:Initialize()

		Utils:OpenSettingsOnLoading()

		Utils:PrintDebug("Addon fully loaded.")
	end
end

function CommodumFrame:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
	Utils:PrintDebug(string.format(
		"Event 'PLAYER_ENTERING_WORLD' fired. Payload: isInitialLogin=%s, isReloadingUi=%s",
		tostring(isInitialLogin), tostring(isReloadingUi)
	))

	Utils:ApplyMilitaryTimeSetting()
end

function CommodumFrame:FACTION_STANDING_CHANGED(_, factionID, updatedStanding)
	Utils:PrintDebug(string.format(
		"Event 'FACTION_STANDING_CHANGED' fired. Payload: factionID=%s, updatedStanding=%s",
		tostring(factionID), tostring(updatedStanding)
	))

	Utils:WatchFaction(factionID)
end

CommodumFrame:RegisterEvent("ADDON_LOADED")
CommodumFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CommodumFrame:RegisterEvent("FACTION_STANDING_CHANGED")
CommodumFrame:SetScript("OnEvent", CommodumFrame.OnEvent)

SLASH_Commodum1, SLASH_Commodum2 = '/com', '/commodum'

SlashCmdList["Commodum"] = SlashCommand
