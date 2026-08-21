local addonName, COM = ...

-- Library
local AWL = ArcaneWizardLibrary

-- Module imports
local Options = COM.Modules.Options
local QualityOfLife = COM.Modules.QualityOfLife
local Utils = COM.Modules.Utils

--------------
--- Frames ---
--------------

local CommodumFrame = CreateFrame("Frame", "Commodum")

-----------------------
--- Local Functions ---
-----------------------

local function SlashCommand(msg)
	local command = strtrim(msg or "")

	if command == "" then
		Utils:OpenSettings()
	elseif command == "changelog" then
		AWL.Frames:OpenChangelog(addonName, COM.CHANGELOG)
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
		QualityOfLife:InitializeAutoSell()
		QualityOfLife:ApplyLootToastSetting()

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

function CommodumFrame:MERCHANT_SHOW()
	QualityOfLife:RepairItemsAutomatically()
	QualityOfLife:StartAutoSell()
end

function CommodumFrame:MERCHANT_CLOSED()
	QualityOfLife:StopAutoSell()
end

function CommodumFrame:LOOT_ITEM_ROLL_WON(_, itemLink, rollQuantity, rollType, roll, upgraded)
	Utils:PrintDebug(string.format(
		"Event 'LOOT_ITEM_ROLL_WON' fired. Payload: itemLink=%s, rollQuantity=%s, rollType=%s, roll=%s, upgraded=%s",
		tostring(itemLink), tostring(rollQuantity), tostring(rollType), tostring(roll), tostring(upgraded)
	))
end

function CommodumFrame:SHOW_LOOT_TOAST(_, typeIdentifier, itemLink, quantity, specID, sex, personalLootToast, toastMethod, lessAwesome, upgraded, corrupted)
	Utils:PrintDebug(string.format(
		"Event 'SHOW_LOOT_TOAST' fired. Payload: typeIdentifier=%s, itemLink=%s, quantity=%s, specID=%s, sex=%s, personalLootToast=%s, toastMethod=%s, lessAwesome=%s, upgraded=%s, corrupted=%s",
		tostring(typeIdentifier), tostring(itemLink), tostring(quantity), tostring(specID), tostring(sex), tostring(personalLootToast), tostring(toastMethod), tostring(lessAwesome), tostring(upgraded), tostring(corrupted)
	))

	QualityOfLife:HandleLootToast(typeIdentifier, itemLink, quantity, specID, sex, personalLootToast, toastMethod, lessAwesome, upgraded, corrupted)
end

function CommodumFrame:SHOW_LOOT_TOAST_UPGRADE(_, itemLink, quantity, specID, sex, baseQuality, personalLootToast, lessAwesome)
	Utils:PrintDebug(string.format(
		"Event 'SHOW_LOOT_TOAST_UPGRADE' fired. Payload: itemLink=%s, quantity=%s, specID=%s, sex=%s, baseQuality=%s, personalLootToast=%s, lessAwesome=%s",
		tostring(itemLink), tostring(quantity), tostring(specID), tostring(sex), tostring(baseQuality), tostring(personalLootToast), tostring(lessAwesome)
	))
end

function CommodumFrame:SHOW_LOOT_TOAST_LEGENDARY_LOOTED(_, itemLink)
	Utils:PrintDebug(string.format(
		"Event 'SHOW_LOOT_TOAST_LEGENDARY_LOOTED' fired. Payload: itemLink=%s",
		tostring(itemLink)
	))
end

function CommodumFrame:SHOW_PVP_FACTION_LOOT_TOAST(_, typeIdentifier, itemLink, quantity, specID, sex, personalLootToast, lessAwesome)
	Utils:PrintDebug(string.format(
		"Event 'SHOW_PVP_FACTION_LOOT_TOAST' fired. Payload: typeIdentifier=%s, itemLink=%s, quantity=%s, specID=%s, sex=%s, personalLootToast=%s, lessAwesome=%s",
		tostring(typeIdentifier), tostring(itemLink), tostring(quantity), tostring(specID), tostring(sex), tostring(personalLootToast), tostring(lessAwesome)
	))
end

function CommodumFrame:SHOW_RATED_PVP_REWARD_TOAST(_, typeIdentifier, itemLink, quantity, specID, sex, personalLootToast, lessAwesome)
	Utils:PrintDebug(string.format(
		"Event 'SHOW_RATED_PVP_REWARD_TOAST' fired. Payload: typeIdentifier=%s, itemLink=%s, quantity=%s, specID=%s, sex=%s, personalLootToast=%s, lessAwesome=%s",
		tostring(typeIdentifier), tostring(itemLink), tostring(quantity), tostring(specID), tostring(sex), tostring(personalLootToast), tostring(lessAwesome)
	))
end

CommodumFrame:RegisterEvent("ADDON_LOADED")
CommodumFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CommodumFrame:RegisterEvent("FACTION_STANDING_CHANGED")
CommodumFrame:RegisterEvent("MERCHANT_SHOW")
CommodumFrame:RegisterEvent("MERCHANT_CLOSED")
CommodumFrame:RegisterEvent("LOOT_ITEM_ROLL_WON")
CommodumFrame:RegisterEvent("SHOW_LOOT_TOAST")
CommodumFrame:RegisterEvent("SHOW_LOOT_TOAST_UPGRADE")
CommodumFrame:RegisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED")
CommodumFrame:RegisterEvent("SHOW_PVP_FACTION_LOOT_TOAST")
CommodumFrame:RegisterEvent("SHOW_RATED_PVP_REWARD_TOAST")
CommodumFrame:SetScript("OnEvent", CommodumFrame.OnEvent)

SLASH_Commodum1, SLASH_Commodum2 = '/com', '/commodum'

SlashCmdList["Commodum"] = SlashCommand
