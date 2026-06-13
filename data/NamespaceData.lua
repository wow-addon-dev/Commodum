local addonName, COM = ...

COM.settings = COM.settings or {}
COM.data = COM.data or {}
COM.state = COM.state or {}
COM.modules = COM.modules or {}

local AWL = ArcaneWizardLibrary

AWL:NewAddon(addonName, {
	debugEnabled = function()
		return COM.settings.general and COM.settings.general["debug-mode"]
	end
})