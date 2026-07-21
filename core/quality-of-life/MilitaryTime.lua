local _, COM = ...

-- Current module
local QualityOfLife = COM.Modules.QualityOfLife

------------------------
--- Module Functions ---
------------------------

function QualityOfLife:ApplyMilitaryTimeSetting()
	SetCVar("timeMgrUseMilitaryTime", COM.Settings.qualityOfLife["military-time"] and 1 or 0)
end
