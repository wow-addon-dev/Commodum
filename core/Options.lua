local addonName, COM = ...

-- Library
local AWL = ArcaneWizardLibrary
local Addon = AWL:GetAddon(addonName)

-- Localization
local L = COM.Localization

-- Current module
local Options = COM.Modules.Options

-- Module imports
local QualityOfLife = COM.Modules.QualityOfLife
local Utils = COM.Modules.Utils

-- Variables
local minimapButtonProxy = setmetatable({}, {
	__index = function(_, key)
		if key == "hide" then
			return not COM.Settings.general["minimap-button"]["hide"]
		end
	end,
	__newindex = function(_, key, value)
		if key ~= "hide" then
			return
		end

		COM.Settings.general["minimap-button"]["hide"] = not value

		if value then
			Utils.minimapButton:Show("Commodum")
		else
			Utils.minimapButton:Hide("Commodum")
		end
	end,
})

------------------------
--- Module Functions ---
------------------------

function Options:Initialize()
	local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.general"]))

	-- Minimap Button
	AWL.Settings:AddCheckbox(category, {
		variableTable = minimapButtonProxy,
		settingKey    = addonName .. "_hide",
		variableName  = "hide",
		name          = L["options.general.minimap-button.name"],
		tooltip       = L["options.general.minimap-button.tooltip"],
		default       = true
	})

	-- Debug Mode
	AWL.Settings:AddCheckbox(category, {
		variableTable = COM.Settings.general,
		settingKey    = addonName .. "_debug-mode",
		variableName  = "debug-mode",
		name          = L["options.general.debug-mode.name"],
		tooltip       = L["options.general.debug-mode.tooltip"],
		default       = false
	})

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.quality-of-life"]))

	-- Military Time
	AWL.Settings:AddCheckbox(category, {
		variableTable = COM.Settings.qualityOfLife,
		settingKey    = addonName .. "_military-time",
		variableName  = "military-time",
		name          = L["options.quality-of-life.military-time.name"],
		tooltip       = L["options.quality-of-life.military-time.tooltip"],
		default       = true,
		onClick       = function() QualityOfLife:ApplyMilitaryTimeSetting() end
	})

	-- Watched Faction
	AWL.Settings:AddCheckbox(category, {
		variableTable = COM.Settings.qualityOfLife,
		settingKey    = addonName .. "_watched-faction",
		variableName  = "watched-faction",
		name          = L["options.quality-of-life.watched-faction.name"],
		tooltip       = L["options.quality-of-life.watched-faction.tooltip"],
		default       = true
	})

	-- Profiles Section
	AWL.Settings:AddProfilesSection(layout, {
		useAccountProfile = Utils:IsAccountProfile(),
		onSwitchProfile = function()
			Utils:ToggleProfileMode()
			ReloadUI()
		end,
		onDeleteCharacterProfiles = function()
			Utils:ResetAllCharacterProfiles()
			ReloadUI()
		end
	})

	-- About Section
	AWL.Settings:AddAboutSection(layout, addonName)

	Settings.RegisterAddOnCategory(category)

	Addon:SetMainCategoryId(category:GetID())
end
