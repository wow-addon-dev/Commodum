local addonName, COM = ...

local L = COM.Localization
local Utils = COM.Utils

local AWL = ArcaneWizardLibrary

local Options = {}

----------------------
--- Local Funtions ---
----------------------

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

---------------------
--- Main Funtions ---
---------------------

function Options:Initialize()
    local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.general"]))

    -- Notification
    AWL.Settings:AddCheckbox(category, {
        variableTable = COM.options.general,
        settingKey    = addonName .. "_notification",
        variableName  = "notification",
        name          = L["options.general.notification.name"],
        tooltip       = L["options.general.notification.tooltip"],
        default       = true
    })

    -- Minimap Button Visibility
    AWL.Settings:AddCheckbox(category, {
        variableTable = minimapButtonProxy,
        settingKey    = addonName .. "_hide",
        variableName  = "hide",
        name          = L["options.general.minimap-button.name"],
        tooltip       = L["options.general.minimap-button.tooltip"],
        default       = true
    })

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.quality-of-life"]))

    -- Military Time
    AWL.Settings:AddCheckbox(category, {
        variableTable = COM.options.qualityOfLife,
        settingKey    = addonName .. "_military-time",
        variableName  = "military-time",
        name          = L["options.quality-of-life.military-time.name"],
        tooltip       = L["options.quality-of-life.military-time.tooltip"],
        default       = true
    })

    -- Watched Faction
    AWL.Settings:AddCheckbox(category, {
        variableTable = COM.options.qualityOfLife,
        settingKey    = addonName .. "_watched-faction",
        variableName  = "watched-faction",
        name          = L["options.quality-of-life.watched-faction.name"],
        tooltip       = L["options.quality-of-life.watched-faction.tooltip"],
        default       = true
    })

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.other"]))

    -- Debug Mode
    AWL.Settings:AddCheckbox(category, {
        variableTable = COM.options.other,
        settingKey    = addonName .. "_debug-mode",
        variableName  = "debug-mode",
        name          = L["options.other.debug-mode.name"],
        tooltip       = L["options.other.debug-mode.tooltip"],
        default       = false
    })

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.about"]))

    -- Game Version
    AWL.Settings:AddInfoText(layout, {
        leftText  = L["options.about.game-version"],
        rightText = COM.GAME_VERSION .. " (" .. COM.GAME_FLAVOR .. ")",
        height    = "compact"
    })

    -- Addon Version
    AWL.Settings:AddInfoText(layout, {
        leftText  = L["options.about.addon-version"],
        rightText = COM.ADDON_VERSION .. " (" .. COM.ADDON_BUILD_DATE .. ")",
        height    = "compact"
    })

    -- Library Version
    AWL.Settings:AddInfoText(layout, {
        leftText  = L["options.about.lib-version"],
        rightText = AWL.ADDON_VERSION .. " (" .. AWL.ADDON_BUILD_DATE .. ")",
        height    = "compact"
    })

    -- Author
    AWL.Settings:AddInfoText(layout, {
        leftText  = L["options.about.author"],
        rightText = COM.ADDON_AUTHOR
    })

    -- GitHub Link
    AWL.Settings:AddButton(layout, {
        name       = L["options.about.button-github.name"],
        buttonText = L["options.about.button-github.button"],
        tooltip    = L["options.about.button-github.tooltip"],
        onClick    = function() AWL.Dialogs:ShowLinkDialog(COM.LINK_GITHUB) end
    })


    Settings.RegisterAddOnCategory(category)

    COM.MAIN_CATEGORY_ID = category:GetID()
end

COM.Options = Options
