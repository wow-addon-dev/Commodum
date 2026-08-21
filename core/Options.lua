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
			Utils.minimapButton:Show(addonName)
		else
			Utils.minimapButton:Hide(addonName)
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
		variableTable	= minimapButtonProxy,
		settingKey		= addonName .. "_hide",
		variableName	= "hide",
		name			= L["options.general.minimap-button.name"],
		tooltip			= L["options.general.minimap-button.tooltip"],
		default			= true
	})

	-- Debug Mode
	AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.general,
		settingKey		= addonName .. "_debug-mode",
		variableName	= "debug-mode",
		name			= L["options.general.debug-mode.name"],
		tooltip			= L["options.general.debug-mode.tooltip"],
		default			= false
	})

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.quality-of-life"]))

	local _, isInterfaceExpanded = AWL.Settings:AddExpandableHeader(layout, L["options.quality-of-life.section.interface"])

	-- Military Time
	AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_military-time",
		variableName	= "military-time",
		name			= L["options.quality-of-life.military-time.name"],
		tooltip			= L["options.quality-of-life.military-time.tooltip"],
		default			= true,
		onClick			= function() QualityOfLife:ApplyMilitaryTimeSetting() end,
		shownPredicate	= isInterfaceExpanded
	})

	-- Watched Faction
	AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_watched-faction",
		variableName	= "watched-faction",
		name			= L["options.quality-of-life.watched-faction.name"],
		tooltip			= L["options.quality-of-life.watched-faction.tooltip"],
		default			= true,
		shownPredicate	= isInterfaceExpanded
	})

	local _, isLootToastsExpanded = AWL.Settings:AddExpandableHeader(layout, L["options.quality-of-life.section.loot-toasts"])

	-- Hide Loot Toasts
	local initializerHideLootToasts, settingHideLootToasts = AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_hide-loot-toasts",
		variableName	= "hide-loot-toasts",
		name			= L["options.quality-of-life.hide-loot-toasts.name"],
		tooltip			= L["options.quality-of-life.hide-loot-toasts.tooltip"],
		default			= false,
		onClick			= function() QualityOfLife:ApplyLootToastSetting() end,
		shownPredicate	= isLootToastsExpanded
	})

	-- Hide Item Loot Toasts
	AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_hide-loot-toasts-item",
		variableName	= "hide-loot-toasts-item",
		name			= L["options.quality-of-life.hide-loot-toasts.item.name"],
		tooltip			= L["options.quality-of-life.hide-loot-toasts.item.tooltip"],
		default			= true,
		parentInit		= initializerHideLootToasts,
		parentCondition	= function() return settingHideLootToasts:GetValue() end,
		shownPredicate	= isLootToastsExpanded
	})

	-- Hide Money Loot Toasts
	AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_hide-loot-toasts-money",
		variableName	= "hide-loot-toasts-money",
		name			= L["options.quality-of-life.hide-loot-toasts.money.name"],
		tooltip			= L["options.quality-of-life.hide-loot-toasts.money.tooltip"],
		default			= true,
		parentInit		= initializerHideLootToasts,
		parentCondition	= function() return settingHideLootToasts:GetValue() end,
		shownPredicate	= isLootToastsExpanded
	})

	-- Hide Currency Loot Toasts
	AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_hide-loot-toasts-currency",
		variableName	= "hide-loot-toasts-currency",
		name			= L["options.quality-of-life.hide-loot-toasts.currency.name"],
		tooltip			= L["options.quality-of-life.hide-loot-toasts.currency.tooltip"],
		default			= true,
		parentInit		= initializerHideLootToasts,
		parentCondition	= function() return settingHideLootToasts:GetValue() end,
		shownPredicate	= isLootToastsExpanded
	})

	local _, isMerchantExpanded = AWL.Settings:AddExpandableHeader(layout, L["options.quality-of-life.section.merchant"])

	-- Automatically Repair Items
	AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_auto-repair",
		variableName	= "auto-repair",
		name			= L["options.quality-of-life.auto-repair.name"],
		tooltip			= L["options.quality-of-life.auto-repair.tooltip"],
		default			= false,
		shownPredicate	= isMerchantExpanded
	})

	-- Automatically Sell Marked Items
	local initializerAutoSellMarked, settingAutoSellMarked = AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_auto-sell",
		variableName	= "auto-sell",
		name			= L["options.quality-of-life.auto-sell.name"],
		tooltip			= L["options.quality-of-life.auto-sell.tooltip"],
		default			= false,
		shownPredicate	= isMerchantExpanded
	})

	-- Marking Modifier
	AWL.Settings:AddDropdown(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_auto-sell-marking-modifier",
		variableName	= "auto-sell-marking-modifier",
		name			= L["options.auto-sell.marking-modifier.name"],
		tooltip			= L["options.auto-sell.marking-modifier.tooltip"],
		default			= "ALT",
		options			= {
			{ value = "ALT", label = L["auto-sell.marking-modifier.alt"] },
			{ value = "CTRL", label = L["auto-sell.marking-modifier.ctrl"] },
			{ value = "SHIFT", label = L["auto-sell.marking-modifier.shift"] }
		},
		parentInit		= initializerAutoSellMarked,
		parentCondition	= function() return settingAutoSellMarked:GetValue() end,
		shownPredicate	= isMerchantExpanded
	})

	-- Automatically Sell Poor-Quality Items
	AWL.Settings:AddCheckbox(category, {
		variableTable	= COM.Settings.qualityOfLife,
		settingKey		= addonName .. "_auto-sell-poor",
		variableName	= "auto-sell-poor",
		name			= L["options.auto-sell.poor.name"],
		tooltip			= L["options.auto-sell.poor.tooltip"],
		default			= false,
		shownPredicate	= isMerchantExpanded
	})

	-- Profiles Section
	AWL.Settings:AddProfilesSection(layout, {
		useAccountProfile			= Utils:IsAccountProfile(),
		onSwitchProfile				= function()
			Utils:ToggleProfileMode()
			ReloadUI()
		end,
		onDeleteCharacterProfiles	= function()
			Utils:ResetAllCharacterProfiles()
			ReloadUI()
		end
	})

	-- About Section
	AWL.Settings:AddAboutSection(layout, addonName, COM.CHANGELOG)

	Settings.RegisterAddOnCategory(category)

	Addon:SetMainCategoryId(category:GetID())
end
