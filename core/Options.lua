local addonName, COM = ...

local L = COM.Localization

local QualityOfLife = COM.modules.QualityOfLife
local Utils = COM.modules.Utils

local AWL = ArcaneWizardLibrary

local Options = {}

-----------------------
--- Local Functions ---
-----------------------

local minimapButtonProxy = setmetatable({}, {
	__index = function(_, key)
		if key == "hide" then
			return not COM.settings.general["minimap-button"]["hide"]
		end
	end,
	__newindex = function(_, key, value)
		if key ~= "hide" then
			return
		end

		COM.settings.general["minimap-button"]["hide"] = not value

		if value then
			Utils.minimapButton:Show("Commodum")
		else
			Utils.minimapButton:Hide("Commodum")
		end
	end,
})

------------------------
--- Public Functions ---
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
		variableTable = COM.settings.general,
		settingKey    = addonName .. "_debug-mode",
		variableName  = "debug-mode",
		name          = L["options.general.debug-mode.name"],
		tooltip       = L["options.general.debug-mode.tooltip"],
		default       = false
	})

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.quality-of-life"]))

	-- Military Time
	AWL.Settings:AddCheckbox(category, {
		variableTable = COM.settings.qualityOfLife,
		settingKey    = addonName .. "_military-time",
		variableName  = "military-time",
		name          = L["options.quality-of-life.military-time.name"],
		tooltip       = L["options.quality-of-life.military-time.tooltip"],
		default       = true,
		onClick       = function() QualityOfLife:ApplyMilitaryTimeSetting() end
	})

	-- Watched Faction
	AWL.Settings:AddCheckbox(category, {
		variableTable = COM.settings.qualityOfLife,
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
	AWL.Settings:AddAboutSection(layout, {
		gameVersion    = COM.GAME_VERSION,
		gameFlavor     = COM.GAME_FLAVOR,
		addonVersion   = COM.ADDON_VERSION,
		addonBuildDate = COM.ADDON_BUILD_DATE,
		addonAuthor    = COM.ADDON_AUTHOR,
		githubLink     = COM.LINK_GITHUB
	})

	Settings.RegisterAddOnCategory(category)

	COM.MAIN_CATEGORY_ID = category:GetID()
end

COM.modules.Options = Options
