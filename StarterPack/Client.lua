--[[
	Apperantly, I was using BSD's coding standerd without even knowing it.

	"Please for the love of all that is holy, define your variables properly."
	~ nisan / nodius
]]--


--Services--
local ReplicatedStorage							= game:GetService('ReplicatedStorage')
local Players									= game:GetService('Players')
local UserInputService							= game:GetService('UserInputService')

--Character Variables--
local Player 									= Players.LocalPlayer

repeat wait() until Player.Character

local Mouse										= Player:GetMouse()

--Events--
local SwordEquip								= ReplicatedStorage:WaitForChild("SwordEquip")
local SwordAttacks								= ReplicatedStorage:WaitForChild("SwordAttacks")

--Booleans--
local Combo										= true
local Attack									= false
local SpinCooldown								= true
local Debounce									= false
local OrbCooldown								= true

--Integers--
local MultipleAttacks							= 0
local SpinAttackI								= 0
local OrbAttackI								= 0


--Animation Handler--
local function Animation(ID)
	local Animation 							= Instance.new("Animation")
		  Animation.AnimationId			  		= "rbxassetid://" .. ID
		  Animation.Name 						= "Idle"

	local AnimationTrack 						= Player.Character.Humanoid:LoadAnimation(Animation)
		  AnimationTrack:Play()
end
--End of Animation Handler--



--Input Event--
UserInputService.InputBegan:Connect(function(Input, GPE)
	if GPE then return end
	
	if Input.KeyCode == Enum.KeyCode.Q then
		SwordEquip:FireServer("Weld")
	end
	
	if Input.KeyCode == Enum.KeyCode.E then
		if Player.Character:FindFirstChild("MainWeapon") and SpinCooldown == true and Player.Character:FindFirstChild("MainWeapon").TextureID == "http://www.roblox.com/asset/?id=12224218" then
			SpinCooldown 						= false
			if SpinAttackI == 0 then
			   SpinAttackI 						= 1
				Animation(6147735670)
			   SpinAttackI						= 0
			end
		end
		if Debounce == false then
			Debounce							= true
			SwordAttacks:FireServer("Spin")
			wait(5)
			Debounce							= false
			SpinCooldown						= true
		end
	end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if Player.Character:FindFirstChild("MainWeapon") and Combo == true then
			Combo 								= false
			if MultipleAttacks == 0 then
			   MultipleAttacks 					= 1
				Animation(6266233600)
			elseif MultipleAttacks == 1 then
				   MultipleAttacks 				= 2
				Animation(6266232602)
			elseif MultipleAttacks == 2 then
				   MultipleAttacks 				= 0
				Animation(6266231175)
			end
		end
		if Attack == false then
			Attack 								= true
			SwordAttacks:FireServer("Slash")
			wait(0.5)
			Attack								= false
			Combo								= true
		end
	end
end)
--End of Input Event--
