local addonName, COM = ...

local L = COM.Localization

local AWL = ArcaneWizardLibrary
local Addon = AWL:GetAddon(addonName)

local compartmentHandlers = Addon:CreateCompartmentHandlers({
	tooltip = L["minimap-button.tooltip"]
})

------------------------
--- Public Functions ---
------------------------

function Commodum_CompartmentOnEnter(self, button)
	compartmentHandlers.OnEnter(self, button)
end

function Commodum_CompartmentOnLeave()
	compartmentHandlers.OnLeave()
end

function Commodum_CompartmentOnClick(self, button)
	compartmentHandlers.OnClick(self, button)
end