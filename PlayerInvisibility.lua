local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RemoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local RemoteEventInputBeganInvisibility = RemoteEventsFolder:WaitForChild("InputBeganInvisibility")
local RemoteEventInputEndedInvisibility = RemoteEventsFolder:WaitForChild("InputEndedInvisibility")

local ConnectionRemoteEventInputBeganInvisibility
local ConnectionRemoteEventInputEndedInvisibility

local PlayerInDebounce = {}

local CountsPlayerActivateRemoteEvent = {}

local KickMessage = "Your Are Kicked for Activated a RemoteEvent To Many Times"

local PlayerdebounceDesactivatedInvisibility = {}

--[[General explanation of the scripts, 1 function is used to Make the parts of the Character Invisible, 
a for cycle is used to iterate through the parts and it is verified if they are baseparts, meshpart or 
accessory , and a function task.spawn() is used so that a Tween is executed in another thread that will
make the part invisible in 0.4 seconds, then another function that does the same but only changes the transparency
value, then the InputBegan and InputEnded events to use the 3rd Function to verify the key and if you are pressing 
it or releasing it and thus call the corresponding functions]]

function MakeBodyInvisibility(Character)

	for _, part in pairs(Character:GetChildren()) do

		if part.Name == "HumanoidRootPart" then continue end

		if part:IsA("BasePart") or part:IsA("MeshPart") then

			if part.Name == "Head" then

				task.spawn(function()

					local Face = part:FindFirstChild("face")

					local TweenInvi = TweenService:Create(Face,TweenInfo.new(0.4), { Transparency = 1 })--[[ TweenInfo.new(0.4) can change "0.4"
				to another value,
				as long as it takes to perform the transparency ]]

					TweenInvi:Play()

				end)

			end

			task.spawn(function()

				local TweenInvi = TweenService:Create(part,TweenInfo.new(0.4), { Transparency = 1 }) --[[ TweenInfo.new(0.4) can change "0.4"
				to another value,
				as long as it takes to perform the transparency ]]

				TweenInvi:Play()

			end)

		elseif part:IsA("Accessory") then

			for _, parts in pairs(part:GetChildren()) do

				if parts:IsA("BasePart") or part:IsA("MeshPart") then

					task.spawn(function()

						local TweenInvi2 = TweenService:Create(parts,TweenInfo.new(0.4), { Transparency = 1 })--[[ TweenInfo.new(0.4) can change "0.4"
				to another value,
				as long as it takes to perform the transparency ]]

						TweenInvi2:Play()

					end)

				end

			end

		end
	end


end

function MakeBodyVisible(Player,Character)
	
	if PlayerdebounceDesactivatedInvisibility[Player] then return end
	
	PlayerdebounceDesactivatedInvisibility[Player] = true
	
	task.delay(4,function()
		
		PlayerdebounceDesactivatedInvisibility[Player] = nil
		
	end)
	
	for _, part in pairs(Character:GetChildren()) do

		if part.Name == "HumanoidRootPart" then continue end

		if part:IsA("BasePart") or part:IsA("MeshPart") then

			if part.Name == "Head" then

				task.spawn(function()

					local Face = part:FindFirstChild("face")

					local TweenInvi = TweenService:Create(Face,TweenInfo.new(0.4), { Transparency = 0 })--[[ TweenInfo.new(0.4) can change "0.4"
				to another value,
				as long as it takes to perform the transparency ]]

					TweenInvi:Play()

				end)

			end

			task.spawn(function()

				local TweenInvi = TweenService:Create(part,TweenInfo.new(0.4), { Transparency = 0 })--[[ TweenInfo.new(0.4) can change "0.4"
				to another value,
				as long as it takes to perform the transparency ]]

				TweenInvi:Play()

			end)

		elseif part:IsA("Accessory") then

			for _, parts in pairs(part:GetChildren()) do

				if parts:IsA("BasePart") or part:IsA("MeshPart") then

					task.spawn(function()

						local TweenInvi2 = TweenService:Create(parts,TweenInfo.new(0.4), { Transparency = 0 })--[[ TweenInfo.new(0.4) can change "0.4"
				to another value,
				as long as it takes to perform the transparency ]]

						TweenInvi2:Play()

					end)

				end

			end

		end
	end

end


function AntiSpawnRemoteEvent(Player, Character)
	
	if PlayerInDebounce[Player] then
		
		if CountsPlayerActivateRemoteEvent[Player] == 6 then
			
			Player:Kick(KickMessage)
			
		end
		
		if CountsPlayerActivateRemoteEvent[Player] == nil then
			
			CountsPlayerActivateRemoteEvent[Player] = 1
			
			return
			
		end
		
		CountsPlayerActivateRemoteEvent[Player] = CountsPlayerActivateRemoteEvent[Player] + 1
		
		return
	end
	
	PlayerInDebounce[Player] = true
	
	task.delay(4,function()
		
		PlayerInDebounce[Player] = nil
		
	end)
	
	MakeBodyInvisibility(Character)
	
end

ConnectionRemoteEventInputBeganInvisibility = RemoteEventInputBeganInvisibility.OnServerEvent:Connect(AntiSpawnRemoteEvent)
	
ConnectionRemoteEventInputEndedInvisibility = RemoteEventInputEndedInvisibility.OnServerEvent:Connect(MakeBodyVisible)