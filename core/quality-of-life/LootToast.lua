local _, COM = ...

-- Current module
local QualityOfLife = COM.Modules.QualityOfLife

------------------------
--- Module Functions ---
------------------------

function QualityOfLife:ApplyLootToastSetting()
	if not AlertFrame then
		return
	end

	local hideLootToasts = COM.Settings.qualityOfLife["hide-loot-toasts"]

	if hideLootToasts then
		AlertFrame:UnregisterEvent("SHOW_LOOT_TOAST")
	else
		AlertFrame:RegisterEvent("SHOW_LOOT_TOAST")
	end
end
