local addonName, COM = ...

COM.Settings = COM.Settings or {}
COM.Data = COM.Data or {}
COM.State = COM.State or {}
COM.Modules = COM.Modules or {}

COM.Modules.Options = COM.Modules.Options or {}
COM.Modules.QualityOfLife = COM.Modules.QualityOfLife or {}
COM.Modules.Utils = COM.Modules.Utils or {}

local AWL = ArcaneWizardLibrary

AWL:NewAddon(addonName, {
	debugEnabled = function()
		return COM.Settings.general and COM.Settings.general["debug-mode"]
	end
})
