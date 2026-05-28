local addonName, COM = ...

local L = COM.Localization

local AWL = ArcaneWizardLibrary

local Utils = {}

-----------------------
--- Local Functions ---
-----------------------

local function CopyTable(source)
	local target = {}

	for key, value in pairs(source) do
		if type(value) == "table" then
			target[key] = CopyTable(value)
		else
			target[key] = value
		end
	end

	return target
end

local function GetCharacterRealmKey()
	return AWL.Utils:GetCharacterRealmKey()
end

------------------------
--- Public Functions ---
------------------------

function Utils:PrintDebug(msg)
	if COM.settings.general["debug-mode"] then
		DEFAULT_CHAT_FRAME:AddMessage(ORANGE_FONT_COLOR:WrapTextInColorCode(addonName .. " (Debug): ") .. msg)
	end
end

function Utils:PrintMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage(NORMAL_FONT_COLOR:WrapTextInColorCode(addonName .. ": ") .. msg)
end

function Utils:IsAccountProfile()
	local characterRealmKey = GetCharacterRealmKey()

	return Commodum_Options_v2.profileKeys[characterRealmKey]["use-account"]
end

function Utils:OpenSettingsOnLoading()
	local characterRealmKey = GetCharacterRealmKey()

	if Commodum_Options_v2.profileKeys[characterRealmKey]["open-settings"] then
		Settings.OpenToCategory(COM.MAIN_CATEGORY_ID)

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

	if not Commodum_Options_v2 then
		Commodum_Options_v2 = {
			["account"] = CopyTable(defaults),
			["profiles"] = {},
			["profileKeys"] = {}
		}
	end

	if not Commodum_Options_v2.profiles[characterRealmKey] then
		Commodum_Options_v2.profiles[characterRealmKey] = CopyTable(defaults)
	end

	if not Commodum_Options_v2.profileKeys[characterRealmKey] then
		Commodum_Options_v2.profileKeys[characterRealmKey] = {
			["use-account"] = true,
			["open-settings"] = false
		}
	end

	if Commodum_Options_v2.profileKeys[characterRealmKey]["use-account"] then
		COM.settings.general = Commodum_Options_v2.account["general"]
		COM.settings.qualityOfLife = Commodum_Options_v2.account["quality-of-life"]
	else
		COM.settings.general = Commodum_Options_v2.profiles[characterRealmKey]["general"]
		COM.settings.qualityOfLife = Commodum_Options_v2.profiles[characterRealmKey]["quality-of-life"]
	end
end

function Utils:InitializeMinimapButton()
	local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Commodum", {
		type     = "launcher",
		text     = "Commodum",
		icon     = COM.MEDIA_PATH .. "icon-round.blp",
		OnClick  = function(self, button)
			if button == "RightButton" then
				if not InCombatLockdown() then
					Settings.OpenToCategory(COM.MAIN_CATEGORY_ID)
				else
					Utils:PrintDebug("In combat. The options menu cannot be opened.")
				end
			end
		end,
		OnTooltipShow = function(tooltip)
			GameTooltip_SetTitle(tooltip, addonName)
			GameTooltip_AddNormalLine(tooltip, COM.ADDON_VERSION .. " (" .. COM.ADDON_BUILD_DATE .. ")")
			GameTooltip_AddBlankLineToTooltip(tooltip)
			GameTooltip_AddHighlightLine(tooltip, L["minimap-button.tooltip"])
		end,
	})

	self.minimapButton = LibStub("LibDBIcon-1.0")
	self.minimapButton:Register("Commodum", LDB, COM.settings.general["minimap-button"])
end

function Utils:ApplyMilitaryTimeSetting()
	SetCVar("timeMgrUseMilitaryTime", COM.settings.qualityOfLife["military-time"] and 1 or 0)
end

function Utils:WatchFaction(factionID)
	if not COM.settings.qualityOfLife["watched-faction"] or not factionID then
		return
	end

	C_Reputation.SetWatchedFactionByID(factionID)
end

COM.modules.Utils = Utils
