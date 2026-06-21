local _, COM = ...

-- Current module
local QualityOfLife = COM.Modules.QualityOfLife

------------------------
--- Module Functions ---
------------------------

function QualityOfLife:ApplyMilitaryTimeSetting()
	SetCVar("timeMgrUseMilitaryTime", COM.Settings.qualityOfLife["military-time"] and 1 or 0)
end

function QualityOfLife:WatchFaction(factionID)
	if not COM.Settings.qualityOfLife["watched-faction"] or not factionID then
		return
	end

	C_Reputation.SetWatchedFactionByID(factionID)
end
