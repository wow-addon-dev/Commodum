local _, COM = ...

-- Localization
local L = COM.Localization

-- Current module
local QualityOfLife = COM.Modules.QualityOfLife

-- Module imports
local Utils = COM.Modules.Utils

-----------------------
--- Local Functions ---
-----------------------

local function GetPressedModifier()
	local pressedModifier

	if IsAltKeyDown() then
		pressedModifier = "ALT"
	end

	if IsControlKeyDown() then
		if pressedModifier then
			return nil
		end

		pressedModifier = "CTRL"
	end

	if IsShiftKeyDown() then
		if pressedModifier then
			return nil
		end

		pressedModifier = "SHIFT"
	end

	return pressedModifier
end

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

function QualityOfLife:GetMarkedItems()
	return COM.Data.autoSell
end

function QualityOfLife:IsItemMarked(itemID)
	return itemID and self:GetMarkedItems()[itemID] == true
end

function QualityOfLife:IsItemSellable(containerInfo)
	return containerInfo and not containerInfo.hasNoValue and GetItemSellPrice(containerInfo) > 0
end

function QualityOfLife:GetMarkingModifier()
	local modifier = COM.Settings.qualityOfLife["auto-sell-marking-modifier"]

	if modifier ~= "ALT" and modifier ~= "CTRL" and modifier ~= "SHIFT" then
		return COM.AUTO_SELL_DEFAULT_MARKING_MODIFIER
	end

	return modifier
end

function QualityOfLife:GetMarkingModifierLabel()
	return L["auto-sell.marking-modifier." .. self:GetMarkingModifier():lower()]
end

function QualityOfLife:IsMarkingModifierDown()
	return GetPressedModifier() == self:GetMarkingModifier()
end

function QualityOfLife:IsAnyAutomaticSellingEnabled()
	return COM.Settings.qualityOfLife["auto-sell"] or COM.Settings.qualityOfLife["auto-sell-poor"]
end

function QualityOfLife:ShouldSellItem(containerInfo)
	if not containerInfo then
		return false
	end

	local sellMarkedItem = COM.Settings.qualityOfLife["auto-sell"] and self:IsItemMarked(containerInfo.itemID)
	local sellPoorItem = COM.Settings.qualityOfLife["auto-sell-poor"] and containerInfo.quality == Enum.ItemQuality.Poor

	return sellMarkedItem or sellPoorItem
end

function QualityOfLife:AddButtonTooltip(button)
	if not COM.Settings.qualityOfLife["auto-sell"] or GameTooltip:GetOwner() ~= button then
		return
	end

	local containerInfo = C_Container.GetContainerItemInfo(button:GetBagID(), button:GetID())

	if not self:IsItemSellable(containerInfo) then
		return
	end

	if self:IsItemMarked(containerInfo.itemID) then
		local itemNameLine = _G[GameTooltip:GetName() .. "TextLeft1"]
		local itemName = itemNameLine and itemNameLine:GetText()

		if itemName and not itemName:find(COM.AUTO_SELL_TOOLTIP_ICON, 1, true) then
			itemNameLine:SetText(itemName .. " " .. COM.AUTO_SELL_TOOLTIP_ICON)
		end

		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["auto-sell.tooltip.marked"]:format(self:GetMarkingModifierLabel()), 1, 0.82, 0)
	else
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["auto-sell.tooltip.unmarked"]:format(self:GetMarkingModifierLabel()), 0.53, 0.81, 0.98)
	end

	GameTooltip:Show()
end

function QualityOfLife:OnModifiedItemClick(button, mouseButton)
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

function QualityOfLife:TryInitializeContainerHooks()
	if self.containerHooksInitialized or not ContainerFrameItemButtonMixin then
		return
	end

	hooksecurefunc(ContainerFrameItemButtonMixin, "OnModifiedClick", function(button, mouseButton)
		QualityOfLife:OnModifiedItemClick(button, mouseButton)
	end)

	hooksecurefunc(ContainerFrameItemButtonMixin, "OnUpdate", function(button)
		QualityOfLife:AddButtonTooltip(button)
	end)

	self.containerHooksInitialized = true
end

function QualityOfLife:CancelSaleTimer()
	if self.saleTimer then
		self.saleTimer:Cancel()
		self.saleTimer = nil
	end
end

function QualityOfLife:ResetSaleState()
	self:CancelSaleTimer()
	self.saleQueue = nil
	self.saleQueueIndex = nil
	self.pendingSale = nil
	self.soldItemCount = nil
	self.soldValue = nil
	self.saleInProgress = false
end

function QualityOfLife:ScheduleSaleStep(delay, callback)
	self:CancelSaleTimer()
	self.saleTimer = C_Timer.NewTimer(delay, callback)
end

function QualityOfLife:FinishSelling()
	local soldItemCount = self.soldItemCount or 0
	local soldValue = self.soldValue or 0

	self:ResetSaleState()

	if soldItemCount == 1 then
		Utils:PrintMessage(L["auto-sell.chat.sold-one"]:format(GetMoneyString(soldValue)))
	elseif soldItemCount > 1 then
		Utils:PrintMessage(L["auto-sell.chat.sold-many"]:format(soldItemCount, GetMoneyString(soldValue)))
	end
end

function QualityOfLife:ProcessNextSale()
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
		self:ScheduleSaleStep(0, function() QualityOfLife:ProcessNextSale() end)
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
	self:ScheduleSaleStep(COM.AUTO_SELL_DELAY, function() QualityOfLife:ConfirmPendingSale() end)
end

function QualityOfLife:ConfirmPendingSale()
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

	if soldCount == 0 and pendingSale.confirmationAttempts < COM.AUTO_SELL_CONFIRMATION_ATTEMPTS then
		pendingSale.confirmationAttempts = pendingSale.confirmationAttempts + 1
		self:ScheduleSaleStep(COM.AUTO_SELL_DELAY, function() QualityOfLife:ConfirmPendingSale() end)
		return
	end

	if soldCount > 0 then
		self.soldItemCount = self.soldItemCount + soldCount
		self.soldValue = self.soldValue + pendingSale.sellPrice * soldCount
	end

	self.pendingSale = nil
	self:ProcessNextSale()
end

function QualityOfLife:BuildSaleQueue()
	local saleQueue = {}

	for bagID = COM.AUTO_SELL_FIRST_BAG_ID, COM.AUTO_SELL_LAST_BAG_ID do
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

function QualityOfLife:StartAutoSell()
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

	self:ScheduleSaleStep(COM.AUTO_SELL_DELAY, function() QualityOfLife:ProcessNextSale() end)
end

function QualityOfLife:StopAutoSell()
	self:ResetSaleState()
end

function QualityOfLife:InitializeAutoSell()
	self:TryInitializeContainerHooks()
end
