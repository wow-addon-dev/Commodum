local addonName, COM = ...

local Utils = COM.Utils
local Options = COM.Options

--------------
--- Frames ---
--------------

local commodumFrame = CreateFrame("Frame", "Commodum")

----------------------
--- Local Funtions ---
----------------------

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

---------------------
--- Main Funtions ---
---------------------

function commodumFrame:OnEvent(event, ...)
	self[event](self, event, ...)
end

function commodumFrame:ADDON_LOADED(_, addOnName)
	if addOnName == addonName then
		Utils:InitializeDatabase()
		Utils:InitializeMinimapButton()
		Options:Initialize()

		Utils:PrintDebug("Addon fully loaded.")
	end
end

function commodumFrame:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
	Utils:PrintDebug("Event 'PLAYER_ENTERING_WORLD' fired. Payload: isInitialLogin=" .. tostring(isInitialLogin) .. ", isReloadingUi=" .. tostring(isReloadingUi))

	SetCVar("timeMgrUseMilitaryTime", 1)
end

function commodumFrame:FACTION_STANDING_CHANGED(_, factionID, updatedStanding)
	Utils:PrintDebug("Event 'FACTION_STANDING_CHANGED' fired. Payload: factionID=" .. tostring(factionID) .. ", updatedStanding=" .. tostring(updatedStanding))

	C_Reputation.SetWatchedFactionByID(factionID)
end

commodumFrame:RegisterEvent("ADDON_LOADED")
commodumFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
commodumFrame:RegisterEvent("FACTION_STANDING_CHANGED")
commodumFrame:SetScript("OnEvent", commodumFrame.OnEvent)

SLASH_Horatum1, SLASH_Horatum2 = '/com', '/commodum'

SlashCmdList["Commodum"] = SlashCommand
