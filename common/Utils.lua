local addonName, COM = ...

-- Library
local AWL = ArcaneWizardLibrary
local Addon = AWL:GetAddon(addonName)

-- Localization
local L = COM.Localization

-- Current module
local Utils = COM.Modules.Utils

------------------------
--- Module Functions ---
------------------------

function Utils:PrintMessage(msg)
	Addon:PrintMessage(msg)
end

function Utils:IsAccountProfile()
	local characterRealmKey = AWL.Utils:GetCharacterRealmKey()

	return Commodum_Options_v2.profileKeys[characterRealmKey]["use-account"]
end

function Utils:OpenSettingsOnLoading()
	local characterRealmKey = AWL.Utils:GetCharacterRealmKey()

	if Commodum_Options_v2.profileKeys[characterRealmKey]["open-settings"] then
		Addon:OpenCategory()

		Commodum_Options_v2.profileKeys[characterRealmKey]["open-settings"] = false
	end
end

function Utils:ToggleProfileMode()
	local characterRealmKey = AWL.Utils:GetCharacterRealmKey()
	local useAccountProfile = self:IsAccountProfile()

	Commodum_Options_v2.profileKeys[characterRealmKey]["use-account"] = not useAccountProfile
	Commodum_Options_v2.profileKeys[characterRealmKey]["open-settings"] = true
end

function Utils:ResetAllCharacterProfiles()
	local characterRealmKey = AWL.Utils:GetCharacterRealmKey()

	Commodum_Options_v2.profiles = {}
	Commodum_Options_v2.profileKeys = {}

	Commodum_Options_v2.profileKeys[characterRealmKey] = {
		["use-account"] = true,
		["open-settings"] = true
	}
end

function Utils:InitializeDatabase()
	local characterRealmKey = AWL.Utils:GetCharacterRealmKey()

	local createdProfile = false
	local createdProfileKey = false

	local defaults = {
		["general"] = {
			["minimap-button"] = {
				["hide"] = false
			}
		},
		["quality-of-life"] = {}
	}

	if not Commodum_Options_v2 then
		Commodum_Options_v2 = {
			["account"] = AWL.Utils:CopyTable(defaults),
			["profiles"] = {},
			["profileKeys"] = {}
		}
	end

	if not Commodum_Options_v2.profiles[characterRealmKey] then
		Commodum_Options_v2.profiles[characterRealmKey] = AWL.Utils:CopyTable(defaults)
		createdProfile = true
	end

	if not Commodum_Options_v2.profileKeys[characterRealmKey] then
		Commodum_Options_v2.profileKeys[characterRealmKey] = {
			["use-account"] = true,
			["open-settings"] = false
		}
		createdProfileKey = true
	end

	local useAccountProfile = Commodum_Options_v2.profileKeys[characterRealmKey]["use-account"]

	if useAccountProfile then
		COM.Settings.general = Commodum_Options_v2.account["general"]
		COM.Settings.qualityOfLife = Commodum_Options_v2.account["quality-of-life"]
	else
		COM.Settings.general = Commodum_Options_v2.profiles[characterRealmKey]["general"]
		COM.Settings.qualityOfLife = Commodum_Options_v2.profiles[characterRealmKey]["quality-of-life"]
	end

	return {
		characterRealmKey = characterRealmKey,
		createdProfile = createdProfile,
		createdProfileKey = createdProfileKey,
		activeProfile = useAccountProfile and "account" or "character"
	}
end

function Utils:InitializeMinimapButton()
	self.minimapButton = Addon:RegisterMinimapButton({
		db = COM.Settings.general["minimap-button"],
		tooltip = L["minimap-button.tooltip"]
	})
end
