local addonName, COM = ...

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

end

COM.Utils = Utils
