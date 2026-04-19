local addonName, COM = ...

local L = COM.Localization

local Utils = {}

---------------------
--- Main Funtions ---
---------------------

function Utils:PrintDebug(msg)
    if COM.options.other["debug-mode"] then
		DEFAULT_CHAT_FRAME:AddMessage(ORANGE_FONT_COLOR:WrapTextInColorCode(addonName .. " (Debug): ")  .. msg)
	end
end

function Utils:PrintMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage(NORMAL_FONT_COLOR:WrapTextInColorCode(addonName .. ": ") .. msg)
end

function Utils:InitializeDatabase()
    if (not Commodum_Options) then
        Commodum_Options = {
			["general"] = {
				["minimap-button"] = {
					["hide"] = false
				}
			},
			["quality-of-life"] = {},
			["other"] = {}
		}
    end

    COM.options = {}
	COM.options.general = Commodum_Options["general"]
    COM.options.qualityOfLife = Commodum_Options["quality-of-life"]
	COM.options.other = Commodum_Options["other"]
end

function Utils:InitializeMinimapButton()
    local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Commodum", {
        type     = "launcher",
        text     = "Commodum",
        icon     = COM.MEDIA_PATH .. "icon-round.blp",
        OnClick  = function(self, button)
            if button == "RightButton" then
                Settings.OpenToCategory(COM.MAIN_CATEGORY_ID)
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
    self.minimapButton:Register("Commodum", LDB, COM.options.general["minimap-button"])
end

COM.Utils = Utils
