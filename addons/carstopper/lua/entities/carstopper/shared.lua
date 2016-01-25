ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "CarStopper"
ENT.Author = "Habo"
ENT.Category = "core-community.de"
ENT.Spawnable = true
ENT.AdminSpawnable = true
function ENT:SetupDataTables()
	self:NetworkVar("Entity",1,"owning_ent")
end
