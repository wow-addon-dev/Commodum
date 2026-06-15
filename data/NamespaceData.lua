local addonName, COM = ...

COM.Settings = COM.Settings or {}
COM.Data = COM.Data or {}
COM.State = COM.State or {}
COM.Modules = COM.Modules or {}

local AWL = ArcaneWizardLibrary

AWL:NewAddon(addonName, {
	debugEnabled = function()
		return COM.Settings.general and COM.Settings.general["debug-mode"]
	end
})