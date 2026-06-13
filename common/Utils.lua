local addonName, COM = ...

local L = COM.Localization

local AWL = ArcaneWizardLibrary
local Addon = AWL:GetAddon(addonName)

local Utils = {}

-----------------------
--- Local Functions ---
-----------------------

local function CopyTable(source)
	return AWL.Utils:CopyTable(source)
end

local function GetCharacterRealmKey()
	return AWL.Utils:GetCharacterRealmKey()
end

------------------------
--- Public Functions ---
------------------------

function Utils:PrintDebug(msg)
	Addon:PrintDebug(msg)
end

function Utils:PrintMessage(msg)
	Addon:PrintMessage(msg)
end

function Utils:IsAccountProfile()
	local characterRealmKey = GetCharacterRealmKey()

	return Commodum_Options_v2.profileKeys[characterRealmKey]["use-account"]
end

function Utils:OpenSettingsOnLoading()
	local characterRealmKey = GetCharacterRealmKey()

	if Commodum_Options_v2.profileKeys[characterRealmKey]["open-settings"] then
		Addon:OpenCategory()

		Commodum_Options_v2.profileKeys[characterRealmKey]["open-settings"] = false
	end
end

function Utils:ToggleProfileMode()
	local characterRealmKey = GetCharacterRealmKey()
	local useAccountProfile = self:IsAccountProfile()

	Commodum_Options_v2.profileKeys[characterRealmKey]["use-account"] = not useAccountProfile
	Commodum_Options_v2.profileKeys[characterRealmKey]["open-settings"] = true
end

function Utils:ResetAllCharacterProfiles()
	local characterRealmKey = GetCharacterRealmKey()

	Commodum_Options_v2.profiles = {}
	Commodum_Options_v2.profileKeys = {}

	Commodum_Options_v2.profileKeys[characterRealmKey] = {
		["use-account"] = true,
		["open-settings"] = true
	}
end

function Utils:InitializeDatabase()
	local characterRealmKey = GetCharacterRealmKey()

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
			["account"] = CopyTable(defaults),
			["profiles"] = {},
			["profileKeys"] = {}
		}
	end

	if not Commodum_Options_v2.profiles[characterRealmKey] then
		Commodum_Options_v2.profiles[characterRealmKey] = CopyTable(defaults)
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
		COM.settings.general = Commodum_Options_v2.account["general"]
		COM.settings.qualityOfLife = Commodum_Options_v2.account["quality-of-life"]
	else
		COM.settings.general = Commodum_Options_v2.profiles[characterRealmKey]["general"]
		COM.settings.qualityOfLife = Commodum_Options_v2.profiles[characterRealmKey]["quality-of-life"]
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
		db = COM.settings.general["minimap-button"],
		tooltip = L["minimap-button.tooltip"]
	})
end

COM.modules.Utils = Utils
