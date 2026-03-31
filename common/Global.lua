local addonName, COM = ...

local L = COM.Localization

---------------------
--- Main Funtions ---
---------------------

function Commodum_CompartmentOnEnter(self, button)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetOwner(button, "ANCHOR_LEFT")

	GameTooltip_SetTitle(GameTooltip, addonName)
	GameTooltip_AddNormalLine(GameTooltip, COM.ADDON_VERSION .. " (" .. COM.ADDON_BUILD_DATE .. ")")
	GameTooltip_AddBlankLineToTooltip(GameTooltip)
	GameTooltip_AddHighlightLine(GameTooltip, L["minimap-button.tooltip"])

	GameTooltip:Show()
end

function Commodum_CompartmentOnLeave()
    GameTooltip:Hide()
end

function Commodum_CompartmentOnClick(_, button)
    if button == "LeftButton" then
		if button == "RightButton" then
        	Settings.OpenToCategory(COM.MAIN_CATEGORY_ID)
		end
    end
end
