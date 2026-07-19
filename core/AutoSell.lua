local _, COM = ...

-- Localization
local L = COM.Localization

-- Current module
local AutoSell = COM.Modules.AutoSell

-- Module imports
local Utils = COM.Modules.Utils

-- Constants
local FIRST_BAG_ID = Enum.BagIndex.Backpack
local LAST_BAG_ID = FIRST_BAG_ID
	+ Constants.InventoryConstants.NumBagSlots
	+ (Constants.InventoryConstants.NumReagentBagSlots or 0)
local SALE_DELAY = 0.2
local SALE_CONFIRMATION_ATTEMPTS = 3
local TOOLTIP_ICON = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:0:0|t"
local DEFAULT_MARKING_MODIFIER = "ALT"

local MARKING_MODIFIER_CHECKS = {
	ALT = function()
		return IsAltKeyDown() and not IsControlKeyDown() and not IsShiftKeyDown()
	end,
	CTRL = function()
		return IsControlKeyDown() and not IsAltKeyDown() and not IsShiftKeyDown()
	end,
	SHIFT = function()
		return IsShiftKeyDown() and not IsAltKeyDown() and not IsControlKeyDown()
	end
}

-----------------------
--- Local Functions ---
-----------------------

local function GetItemSellPrice(containerInfo)
	if not containerInfo or containerInfo.hasNoValue then
		return 0
	end

	return select(11, C_Item.GetItemInfo(containerInfo.hyperlink or containerInfo.itemID)) or 0
end

local function IsMerchantAvailable()
	return MerchantFrame and MerchantFrame:IsShown() and MerchantFrame.selectedTab ~= 2
end

------------------------
--- Module Functions ---
------------------------

function AutoSell:GetMarkedItems()
	return COM.Data.autoSell
end

function AutoSell:IsItemMarked(itemID)
	return itemID and self:GetMarkedItems()[itemID] == true
end

function AutoSell:IsItemSellable(containerInfo)
	return containerInfo and not containerInfo.hasNoValue and GetItemSellPrice(containerInfo) > 0
end

function AutoSell:GetMarkingModifier()
	local modifier = COM.Settings.qualityOfLife["auto-sell-marking-modifier"]

	if not MARKING_MODIFIER_CHECKS[modifier] then
		return DEFAULT_MARKING_MODIFIER
	end

	return modifier
end

function AutoSell:GetMarkingModifierLabel()
	return L["auto-sell.marking-modifier." .. self:GetMarkingModifier():lower()]
end

function AutoSell:IsMarkingModifierDown()
	return MARKING_MODIFIER_CHECKS[self:GetMarkingModifier()]()
end

function AutoSell:IsAnyAutomaticSellingEnabled()
	return COM.Settings.qualityOfLife["auto-sell"] or COM.Settings.qualityOfLife["auto-sell-poor"]
end

function AutoSell:ShouldSellItem(containerInfo)
	if not containerInfo then
		return false
	end

	local sellMarkedItem = COM.Settings.qualityOfLife["auto-sell"] and self:IsItemMarked(containerInfo.itemID)
	local sellPoorItem = COM.Settings.qualityOfLife["auto-sell-poor"] and containerInfo.quality == Enum.ItemQuality.Poor

	return sellMarkedItem or sellPoorItem
end

function AutoSell:AddButtonTooltip(button)
	if not COM.Settings.qualityOfLife["auto-sell"] or GameTooltip:GetOwner() ~= button then
		return
	end

	local containerInfo = C_Container.GetContainerItemInfo(button:GetBagID(), button:GetID())

	if not self:IsItemSellable(containerInfo) then
		return
	end

	if self:IsItemMarked(containerInfo.itemID) then
		local itemNameLine = GameTooltip.TextLeft1
		local itemName = itemNameLine and itemNameLine:GetText()

		if itemName and not itemName:find(TOOLTIP_ICON, 1, true) then
			itemNameLine:SetText(itemName .. " " .. TOOLTIP_ICON)
		end

		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["auto-sell.tooltip.marked"]:format(self:GetMarkingModifierLabel()), 1, 0.82, 0)
	else
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["auto-sell.tooltip.unmarked"]:format(self:GetMarkingModifierLabel()), 0.53, 0.81, 0.98)
	end

	GameTooltip:Show()
end

function AutoSell:OnModifiedItemClick(button, mouseButton)
	if not COM.Settings.qualityOfLife["auto-sell"]
		or mouseButton ~= "RightButton"
		or not self:IsMarkingModifierDown()
	then
		return
	end

	local containerInfo = C_Container.GetContainerItemInfo(button:GetBagID(), button:GetID())

	if not containerInfo or not containerInfo.itemID then
		return
	end

	if not self:IsItemSellable(containerInfo) then
		Utils:PrintMessage(L["auto-sell.chat.cannot-mark"]:format(containerInfo.hyperlink or containerInfo.itemName))
		return
	end

	local markedItems = self:GetMarkedItems()
	local itemID = containerInfo.itemID

	if markedItems[itemID] then
		markedItems[itemID] = nil
		Utils:PrintMessage(L["auto-sell.chat.unmarked"]:format(containerInfo.hyperlink))
	else
		markedItems[itemID] = true
		Utils:PrintMessage(L["auto-sell.chat.marked"]:format(containerInfo.hyperlink))
	end

	if GameTooltip:GetOwner() == button then
		button:OnUpdate()
	end
end

function AutoSell:TryInitializeContainerHooks()
	if self.containerHooksInitialized or not ContainerFrameItemButtonMixin then
		return
	end

	hooksecurefunc(ContainerFrameItemButtonMixin, "OnModifiedClick", function(button, mouseButton)
		AutoSell:OnModifiedItemClick(button, mouseButton)
	end)

	hooksecurefunc(ContainerFrameItemButtonMixin, "OnUpdate", function(button)
		AutoSell:AddButtonTooltip(button)
	end)

	self.containerHooksInitialized = true
end

function AutoSell:CancelSaleTimer()
	if self.saleTimer then
		self.saleTimer:Cancel()
		self.saleTimer = nil
	end
end

function AutoSell:ResetSaleState()
	self:CancelSaleTimer()
	self.saleQueue = nil
	self.saleQueueIndex = nil
	self.pendingSale = nil
	self.soldItemCount = nil
	self.soldValue = nil
	self.saleInProgress = false
end

function AutoSell:ScheduleSaleStep(delay, callback)
	self:CancelSaleTimer()
	self.saleTimer = C_Timer.NewTimer(delay, callback)
end

function AutoSell:FinishSelling()
	local soldItemCount = self.soldItemCount or 0
	local soldValue = self.soldValue or 0

	self:ResetSaleState()

	if soldItemCount == 1 then
		Utils:PrintMessage(L["auto-sell.chat.sold-one"]:format(GetMoneyString(soldValue)))
	elseif soldItemCount > 1 then
		Utils:PrintMessage(L["auto-sell.chat.sold-many"]:format(soldItemCount, GetMoneyString(soldValue)))
	end
end

function AutoSell:ProcessNextSale()
	if not self.saleInProgress or not self:IsAnyAutomaticSellingEnabled() or not IsMerchantAvailable() then
		self:ResetSaleState()
		return
	end

	local entry = self.saleQueue[self.saleQueueIndex]

	if not entry then
		self:FinishSelling()
		return
	end

	self.saleQueueIndex = self.saleQueueIndex + 1

	local containerInfo = C_Container.GetContainerItemInfo(entry.bagID, entry.slotID)

	if not containerInfo
		or containerInfo.itemID ~= entry.itemID
		or containerInfo.isLocked
		or not self:ShouldSellItem(containerInfo)
		or not self:IsItemSellable(containerInfo)
	then
		self:ScheduleSaleStep(0, function() AutoSell:ProcessNextSale() end)
		return
	end

	self.pendingSale = {
		bagID = entry.bagID,
		slotID = entry.slotID,
		itemID = entry.itemID,
		stackCount = containerInfo.stackCount,
		sellPrice = GetItemSellPrice(containerInfo),
		confirmationAttempts = 0
	}

	C_Container.UseContainerItem(entry.bagID, entry.slotID)
	self:ScheduleSaleStep(SALE_DELAY, function() AutoSell:ConfirmPendingSale() end)
end

function AutoSell:ConfirmPendingSale()
	if not self.saleInProgress or not self.pendingSale then
		return
	end

	local pendingSale = self.pendingSale
	local containerInfo = C_Container.GetContainerItemInfo(pendingSale.bagID, pendingSale.slotID)
	local remainingCount = 0

	if containerInfo and containerInfo.itemID == pendingSale.itemID then
		remainingCount = containerInfo.stackCount
	end

	local soldCount = math.max(pendingSale.stackCount - remainingCount, 0)

	if soldCount == 0 and pendingSale.confirmationAttempts < SALE_CONFIRMATION_ATTEMPTS then
		pendingSale.confirmationAttempts = pendingSale.confirmationAttempts + 1
		self:ScheduleSaleStep(SALE_DELAY, function() AutoSell:ConfirmPendingSale() end)
		return
	end

	if soldCount > 0 then
		self.soldItemCount = self.soldItemCount + soldCount
		self.soldValue = self.soldValue + pendingSale.sellPrice * soldCount
	end

	self.pendingSale = nil
	self:ProcessNextSale()
end

function AutoSell:BuildSaleQueue()
	local saleQueue = {}

	for bagID = FIRST_BAG_ID, LAST_BAG_ID do
		for slotID = 1, C_Container.GetContainerNumSlots(bagID) do
			local containerInfo = C_Container.GetContainerItemInfo(bagID, slotID)

			if self:ShouldSellItem(containerInfo) then
				table.insert(saleQueue, {
					bagID = bagID,
					slotID = slotID,
					itemID = containerInfo.itemID
				})
			end
		end
	end

	return saleQueue
end

function AutoSell:StartSelling()
	self:ResetSaleState()

	if not self:IsAnyAutomaticSellingEnabled() then
		return
	end

	local saleQueue = self:BuildSaleQueue()

	if #saleQueue == 0 then
		return
	end

	self.saleQueue = saleQueue
	self.saleQueueIndex = 1
	self.soldItemCount = 0
	self.soldValue = 0
	self.saleInProgress = true

	self:ScheduleSaleStep(SALE_DELAY, function() AutoSell:ProcessNextSale() end)
end

function AutoSell:StopSelling()
	self:ResetSaleState()
end

function AutoSell:Initialize()
	self:TryInitializeContainerHooks()
end
