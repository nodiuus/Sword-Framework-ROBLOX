--[[
	Apperantly, I was using BSD's coding standerd without even knowing it.

	"Please for the love of all that is holy, define your variables properly."
	~ nisan / nodius
]]--



--Services--
local ReplicatedStorage							= game:GetService("ReplicatedStorage")

--Remotes--
local SwordEquip								= ReplicatedStorage:WaitForChild("SwordEquip")
local SwordAttacks								= ReplicatedStorage:WaitForChild("SwordAttacks")

--Objects--
local MainWeapon 								= ReplicatedStorage:FindFirstChild("MainWeapon")


--Events--
game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		
		--Character Variables--
		local Humanoid							= Character:WaitForChild("Humanoid")
		--End Of Variables--
		
		
		--Weld Reference Instance--
		local WeldReference 		 			= Instance.new("Part", Character)
			  WeldReference.Size				= Vector3.new(0.5, 0.5, 0.5)
			  WeldReference.CanCollide 			= false
			  WeldReference.Name 				= "WeldReference"
			  WeldReference.Transparency		= 1
		--End Of Instances
		
		
		--Weld Reference Weld--
		local WeldR 							= Instance.new("Weld", Character["Right Arm"])
			  WeldR.Part0 						= Character["Right Arm"]
			  WeldR.Part1						= WeldReference
			  WeldR.C0							= CFrame.new(0, -1, 0)
		--End Of Reference Weld
		
		
		--Hitbox Instance--
		repeat wait() until Character:FindFirstChild("HumanoidRootPart")
		
		local Hitbox 							= Instance.new("Part", Character)
			  Hitbox.Name 						= "Hitbox"
			  Hitbox.Transparency 				= 1
			  Hitbox.CanCollide				 	= false
			  Hitbox.CFrame 					= Character.HumanoidRootPart.CFrame
			  Hitbox.Size					 	= Vector3.new(4, Character.HumanoidRootPart.Size.Y * 2.75,1.5)
		
		local WeldConstraint 					= Instance.new("WeldConstraint", Hitbox)
			  WeldConstraint.Part0 				= Hitbox
			  WeldConstraint.Part1 				= Character.HumanoidRootPart
		--End Of Instance--
		
		
		--Texture ID Reset--
		if Humanoid.Health > 0 then
			MainWeapon.TextureID				= "http://www.roblox.com/asset/?id=12224218"
		end
		--End Of Reset--
		
	end)
end)



--Remote Event Listener--
SwordEquip.OnServerEvent:Connect(function(Player, Call)
	
	--Character Variables--
	local Character								= Player.Character
	local Humanoid								= Character:WaitForChild("Humanoid")
	
	
	--Weld Variables--
	local WeldReference							= Character:FindFirstChild("WeldReference")
	local Weld 									= Instance.new("Weld", Character["Right Arm"])
	
	
	--Cloning Variables--
	local MainWeaponClone						= ReplicatedStorage.MainWeapon:Clone()
		  MainWeaponClone.Parent				= MainWeapon.Parent
	
	--End Of Variables--
	
	--Animation Handler--
	local function Animation(ID)
		local Animation 						= Instance.new("Animation")
			  Animation.AnimationId			  	= "rbxassetid://" .. ID
			  Animation.Name 					= "Idle"
		
		local AnimationTrack				 	= Character.Humanoid:LoadAnimation(Animation)
			  AnimationTrack:Play()
	end
	
	--End Of Handler
	
	
	--Start Weld--
	if Call == ("Weld") and Character:FindFirstChild("MainWeapon") then
		Character.MainWeapon.Parent				= nil
		MainWeaponClone:Destroy()
		
		for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
			v:Stop()
		end
	else
		
		MainWeaponClone.Parent					= Character
		Weld.Part0 								= WeldReference
		Weld.Part1 								= MainWeaponClone
		Weld.C0 								= CFrame.Angles(0, math.rad(-180), math.rad(90)) * CFrame.new(0, 0, 1.5)
		
		if Character:FindFirstChild("MainWeapon") then
			Animation(6016880637)
		end
	end
	--End Weld--
	
	
end)
	
			

SwordAttacks.OnServerEvent:Connect(function(Player, Call, MousePosition)
	
	local Character								= Player.Character
	
	local Damaging								= true
	local SliceCooldown							= 1
	
	local MainWeaponInstance 					= Character:FindFirstChild("MainWeapon")
	
	--Start Damage Handler--
	local function Damage(DMG)
		if MainWeaponInstance then
			MainWeaponInstance.Touched:Connect(function(Hit)
				local HitHumanoid				= Hit.Parent:FindFirstChild("Humanoid")
				
				--local HitAnimation				= Instance.new("Animation")
					  --HitAnimation.Name			= "Hit"
					  --HitAnimation.AnimationId	= "rbxassetid://".. 6293921646
			
				--local AnimationTrack				 	= HitHumanoid:LoadAnimation(HitAnimation)
					  
				if Hit.Name == "Hitbox" and Damaging == true then
					if HitHumanoid then
						HitHumanoid:TakeDamage(DMG)
						--AnimationTrack:Play()
						Damaging 				= false
					end
				end	
			end)

		end
	end
	
	delay(SliceCooldown, function()
		Damaging = false
	end)
	--End Damage Handler--
		
	
	--Start Autherize--
	local function AutherizeSword(ID, DMG)
		if MainWeaponInstance.TextureID == ID then
			Damage(DMG)
		end
	end
	--End Autherize--
	

	--Start Attacks--
	if Call == ("Slash") then
		Damage(10)
	end
	if Call == ("Spin") then
		AutherizeSword("http://www.roblox.com/asset/?id=12224218", 20)
	end
	--End Attacks--
end)
