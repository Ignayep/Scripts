local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Character = Player.Character or Player.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")
local RemoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local RemoteEventInputBeganInvisibility = RemoteEventsFolder:WaitForChild("InputBeganInvisibility")
local RemoteEventInputEndedInvisibility = RemoteEventsFolder:WaitForChild("InputEndedInvisibility")
local InputBeganConnection
local InputEndedConnection

local debounceInputBegan = false
local debounceTime = 0.4
local IsForGui = false
local debounceInputEnded = false
local DebounceDuration

function InputBeganActivate(inputObject, gameprocessed)
	
	if IsForGui or inputObject.KeyCode == Enum.KeyCode.R and inputObject.UserInputState == Enum.UserInputState.Begin and not gameprocessed then 
		
		if debounceInputBegan then return end
		
		debounceInputBegan = true
		
		IsForGui = false
		
		task.spawn(function()

			for i = 0.1, 4, 0.1 do

				DebounceDuration = i

				task.wait(0.1)

			end

			debounceInputBegan = false

		end)
		
		RemoteEventInputBeganInvisibility:FireServer(Character)
		
	end
	
end

function InputEndedActivate(inputObject, gameprocessed)

	if IsForGui or inputObject.KeyCode == Enum.KeyCode.R and inputObject.UserInputState == Enum.UserInputState.End and not gameprocessed then 
		
		if debounceInputEnded then return end

		debounceInputEnded = true

		task.delay((4-DebounceDuration),function()

			debounceInputEnded = false

		end)
		
		IsForGui = false
		
		RemoteEventInputEndedInvisibility:FireServer(Character)

	end

end

InputBeganConnection = UserInputService.InputBegan:Connect(InputBeganActivate)

InputEndedConnection = UserInputService.InputEnded:Connect(InputEndedActivate)
