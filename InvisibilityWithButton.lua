local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local RemoteEventInputBeganInvisibility = RemoteEventsFolder:WaitForChild("InputBeganInvisibility")
local RemoteEventInputEndedInvisibility = RemoteEventsFolder:WaitForChild("InputEndedInvisibility")
local Players = game:GetService("Players")
local Character = script.Parent
local Player = Players:GetPlayerFromCharacter(Character)
local PlayerGui = Player:WaitForChild("PlayerGui")
local PowersGui = PlayerGui:WaitForChild("PowersGui")
local FramePowerContainer = PowersGui:WaitForChild("PowerContainer")
local ImagenButton = FramePowerContainer:WaitForChild("R")
local ImagenButtonConnection

local DebounceDuration = 4
local Debounce = false


function MakeVisible()
	
	RemoteEventInputEndedInvisibility:FireServer(Character)
	
end

function MakeInvisible()
	
	if Debounce then return end
	
	Debounce = true
	
	task.delay(DebounceDuration,function()
		
		Debounce = false
		
		MakeVisible()
		
	end)
	
	RemoteEventInputBeganInvisibility:FireServer(Character)

end

ImagenButtonConnection = ImagenButton.Activated:Connect(MakeInvisible)

