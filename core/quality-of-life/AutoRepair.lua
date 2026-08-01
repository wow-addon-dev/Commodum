local _, COM = ...

-- Localization
local L = COM.Localization

-- Current module
local QualityOfLife = COM.Modules.QualityOfLife

-- Module imports
local Utils = COM.Modules.Utils

------------------------
--- Module Functions ---
------------------------

function QualityOfLife:RepairItemsAutomatically()
	if not COM.Settings.qualityOfLife["auto-repair"] or not CanMerchantRepair() then
		return
	end

	local repairCost = GetRepairAllCost()

	if repairCost <= 0 then
		return
	end

	if GetMoney() < repairCost then
		Utils:PrintMessage(L["auto-repair.chat.insufficient-funds"])
		return
	end

	RepairAllItems(false)
	Utils:PrintMessage(L["auto-repair.chat.repaired"]:format(GetMoneyString(repairCost)))
end
