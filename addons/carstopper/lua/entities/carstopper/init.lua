
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/mechanics/slider2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:DrawShadow( false )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(150,150,150))
	self.active = false
	self.cd = false
	local phys = self:GetPhysicsObject()
	self.destruct = 1
	phys:Wake()

	self.hp = 10
end



function ENT:OnTakeDamage(dmg)
	self.hp = self.hp - dmg:GetDamage()

	if (self.hp <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		timer.Simple(1, function() self:Remove() end)
	end
end

function ENT:Use(activator,caller)
	if activator:isCP() then
		if !self.active then 
			self.active = true
			self:SetColor(Color(0,255,0))
			self:GetPhysicsObject():EnableMotion(false)
		elseif self.active then
			self.active = false
			self:SetColor(Color(255,0,0))
			self:GetPhysicsObject():EnableMotion(true)
		end
	end
end

function ENT:Think()
	if self.active then
		
	end
end

function ENT:Touch(entity)

	if self.active then
		timer.Simple(1, function() 
			if entity:GetClass() == "prop_vehicle_jeep" then
				entity:Fire("TurnOff", "1", 0)
				entity:Fire("HandBrakeOn", "1", 0)
				entity:Fire("lock", "", 1)
				if self.cd then return end
				self.cd = true
				self.destruct = self.destruct + 1
				timer.Simple(5, function() self.cd = false end)
				if self.destruct >= 2 then
					local effectdata = EffectData()
					effectdata:SetOrigin(self:GetPos())
					effectdata:SetMagnitude(2)
					effectdata:SetScale(2)
					effectdata:SetRadius(3)
					util.Effect("Sparks", effectdata)
					timer.Simple(1, function() self:Remove() end)
				end
				if entity:GetDriver() != NULL then
					entity:GetDriver():ExitVehicle()
				end
			end 
		end)
	end
end


function ENT:OnRemove()

end
