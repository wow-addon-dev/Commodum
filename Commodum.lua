local addonName, COM = ...

--------------
--- Frames ---
--------------

local commodumFrame = CreateFrame("Frame", "Commodum")

----------------------
--- Local Funtions ---
----------------------

local function SlashCommand(msg, editbox)
    if not msg or msg:trim() == "" then
		--Settings.OpenToCategory(COM.MAIN_CATEGORY_ID)
	else
        Utils:PrintDebug("These arguments are not accepted.")
	end
end

---------------------
--- Main Funtions ---
---------------------

function commodumFrame:OnEvent(event, ...)
	self[event](self, event, ...)
end

function commodumFrame:ADDON_LOADED(_, addOnName)
    if addOnName == addonName then
        Utils:PrintDebug("Addon fully loaded.")
    end
end

function commodumFrame:FACTION_STANDING_CHANGED(_, factionID, updatedStanding)
	Utils:PrintDebug("factionID: " .. tostring(factionID) .. " - updatedStanding: " .. tostring(updatedStanding))
	C_Reputation.SetWatchedFactionByID(factionID)
end

commodumFrame:RegisterEvent("FACTION_STANDING_CHANGED")
commodumFrame:SetScript("OnEvent", commodumFrame.OnEvent)

SLASH_Horatum1, SLASH_Horatum2 = '/com', '/commodum'

SlashCmdList["Commodum"] = SlashCommand
