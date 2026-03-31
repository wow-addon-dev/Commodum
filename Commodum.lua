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
    if not msg or msg:trim() == "" then
		Settings.OpenToCategory(COM.MAIN_CATEGORY_ID)
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

		local text = ""
		local _, instanceType, difficulty, difficultyName, _, _, _, instanceID, instanceGroupSize = GetInstanceInfo()
		local delveInfo, delveInfo2, delveInfo3 = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6183), C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6184), C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6185)
		local usedDelveInfo
		--Nemesis Hack to normal/mythic since tiers aren't numbers
		if delveInfo2 and delveInfo2.shownState and delveInfo2.shownState == 1 then
			text = difficultyName .. "(?)"
		elseif delveInfo3 and delveInfo3.shownState and delveInfo3.shownState == 1 then
			text = difficultyName .. "(??) "
		elseif delveInfo and delveInfo.shownState and delveInfo.shownState == 1 then
			usedDelveInfo = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6183)

			local delveTier = 0
			if usedDelveInfo and usedDelveInfo.tierText then
				---@diagnostic disable-next-line: cast-local-type
				delveTier = tonumber(usedDelveInfo.tierText)
			end

			text = difficultyName .. "(" .. delveTier .. ")"
		end

		Utils:PrintDebug(text)

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
