local _, COM = ...

-- Enable only for releases with new features or important changes.
COM.SHOW_UPDATE_NOTICE = true

COM.AUTO_SELL_FIRST_BAG_ID = Enum.BagIndex.Backpack
COM.AUTO_SELL_LAST_BAG_ID = COM.AUTO_SELL_FIRST_BAG_ID
	+ Constants.InventoryConstants.NumBagSlots
	+ (Constants.InventoryConstants.NumReagentBagSlots or 0)
COM.AUTO_SELL_DELAY = 0.1
COM.AUTO_SELL_CONFIRMATION_ATTEMPTS = 3
COM.AUTO_SELL_TOOLTIP_ICON = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:0:0|t"
COM.AUTO_SELL_DEFAULT_MARKING_MODIFIER = "ALT"
