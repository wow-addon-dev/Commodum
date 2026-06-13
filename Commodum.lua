local addonName, COM = ...

local AWL = ArcaneWizardLibrary
local Addon = AWL:GetAddon(addonName)

local Options = COM.modules.Options
local QualityOfLife = COM.modules.QualityOfLife
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
		Addon:OpenCategory()
	else
		Utils:PrintDebug("No arguments will be accepted.")
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
		local dbInit = Utils:InitializeDatabase()
		Utils:InitializeMinimapButton()
		Options:Initialize()

		Utils:OpenSettingsOnLoading()

		Utils:PrintDebug(string.format(
			"InitializeDatabase: key=%s, createdProfile=%s, createdProfileKey=%s, activeProfile=%s",
			tostring(dbInit.characterRealmKey), tostring(dbInit.createdProfile), tostring(dbInit.createdProfileKey), tostring(dbInit.activeProfile)
		))
		Utils:PrintDebug("Addon fully loaded.")
	end
end

function CommodumFrame:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
	Utils:PrintDebug(string.format(
		"Event 'PLAYER_ENTERING_WORLD' fired. Payload: isInitialLogin=%s, isReloadingUi=%s",
		tostring(isInitialLogin), tostring(isReloadingUi)
	))

	QualityOfLife:ApplyMilitaryTimeSetting()
end

function CommodumFrame:FACTION_STANDING_CHANGED(_, factionID, updatedStanding)
	Utils:PrintDebug(string.format(
		"Event 'FACTION_STANDING_CHANGED' fired. Payload: factionID=%s, updatedStanding=%s",
		tostring(factionID), tostring(updatedStanding)
	))

	QualityOfLife:WatchFaction(factionID)
end

CommodumFrame:RegisterEvent("ADDON_LOADED")
CommodumFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CommodumFrame:RegisterEvent("FACTION_STANDING_CHANGED")
CommodumFrame:SetScript("OnEvent", CommodumFrame.OnEvent)

SLASH_Commodum1, SLASH_Commodum2 = '/com', '/commodum'

SlashCmdList["Commodum"] = SlashCommand
