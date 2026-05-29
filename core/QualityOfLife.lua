local _, COM = ...

local QualityOfLife = {}

function QualityOfLife:ApplyMilitaryTimeSetting()
	SetCVar("timeMgrUseMilitaryTime", COM.settings.qualityOfLife["military-time"] and 1 or 0)
end

function QualityOfLife:WatchFaction(factionID)
	if not COM.settings.qualityOfLife["watched-faction"] or not factionID then
		return
	end

	C_Reputation.SetWatchedFactionByID(factionID)
end

COM.modules.QualityOfLife = QualityOfLife
