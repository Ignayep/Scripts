-- Script Made By: Ignayep!

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ParticleEmitterFolder: Folder = ReplicatedStorage:FindFirstChild("ParticleEmitter")
local MagicOpenSkyBlueParticle: ParticleEmitter = ParticleEmitterFolder:FindFirstChild("MagicOpenSkyBlue")
local MagicOpenYellowParticle: ParticleEmitter = ParticleEmitterFolder:FindFirstChild("MagicOpenYellow")
local EventsFolder: Folder = ReplicatedStorage:FindFirstChild("Events")
local BindableEvents: Folder = ReplicatedStorage:FindFirstChild("BindableEvents")
local FinishedBuyRemoveEvent: RemoteEvent = EventsFolder:FindFirstChild("FinishedBuy")
local FinishedBuyBindableEvent: BindableEvent = BindableEvents:FindFirstChild("FinishedBuy")
local PurchasedNowShowEgg2RemoteEvent: RemoteEvent = EventsFolder:FindFirstChild("PurchasedNowShowEgg2")
local PurchasedNowShowThirdEggsRemoveEvent: RemoteEvent = EventsFolder:FindFirstChild("PurchasedNowShowThirdEggs")
local DestroyEggMeshRemoveEvent: RemoteEvent = EventsFolder:FindFirstChild("DestroyEggMesh")
local ModulesFolder: Folder = ReplicatedStorage:FindFirstChild("Modules")
local Module3D = require(ModulesFolder:FindFirstChild("Module3D[Library]"))
local PlayerGui = Player:FindFirstChild("PlayerGui")
local EggSystemGui = PlayerGui:FindFirstChild("EggSystemGui")
local DisplayFrame: Frame = EggSystemGui:FindFirstChild("DisplayFrame")
local TextLabelPetName: TextLabel = DisplayFrame:FindFirstChild("PetName")
local DisplayFrame2: Frame = EggSystemGui:FindFirstChild("DisplayFrame2")
local TextLabelPetName2: TextLabel = DisplayFrame2:FindFirstChild("PetName2")
local DisplayFrame3: Frame = EggSystemGui:FindFirstChild("DisplayFrame3")
local TextLabelPetName3: TextLabel = DisplayFrame3:FindFirstChild("PetName3")
local FlasGui: ScreenGui = EggSystemGui:WaitForChild("FlashGui")
local FlashFrame: Frame = FlasGui:WaitForChild("FlashFrame")
local RenderSteppedConnection
local PurchasedNowShowEggConnection
local PurchasedNowShowThirdEggsRemoveEventConnection
local RunServiceSteppedConnection
local HumanoidDiedConnection

--[[Una breve discripcion del Guion, en este guion existen 2 funciones principales, una de ellas "ShowThreeEggsToPlayer", es una modificacion de  ShowEggToPlayer
para adaptarla a 3 Huevos, En si este script es una Animacion de la Apertura de Un Huevo, de un Tipico sistema de Hatching Egg,  en la cual se muestra una animacion
de apertura del huevo, el cual mueve el huevo 5 Studs arriba de La mitad de la Visualizacion de la Camara luego simula un rebote y una animacion extra
y luego de que el huevo se abre, aparece un pet aleatorio, con su respectivo nombre. ]]

--[[A brief description of the Script, in this script there are 2 main functions, one of them "ShowThreeEggsToPlayer", is a modification of ShowEggToPlayer
to adapt it to 3 Eggs, In itself this script is an Animation of the Opening of an Egg, of a Typical Hatching Egg system, in which an animation is shown
egg opening, which moves the egg 5 studs above the middle of the camera view then simulates a bounce and an extra animation
and after the egg opens, a random pet appears, with its respective name. ]]

local Camera = workspace.CurrentCamera
local HumanoidDead = false

local LerpTimes = {0.3, 0.275, 0.25, 0.25, 0.25, 0.15, 0.25, 0.15, 0.05,0.15,0.05,0.45,0.5, 0.1}

 --[[Se establecen los CFrames o Puntos de Interpolacion
	y se guardan en Tablas para luego recorrer sobre ellos a traves de su indice]]

--[[The Frames or Interpolation Points are established and saved in Tables to later go over them through their index]]

local EndPointsCFrames = { CFrame.new(0, 0, -5 * 1.8), CFrame.new(0, 1.5, -5 * 1.8), CFrame.new(0, 0, -5 * 1.8), 
	CFrame.new(0, 0.5, -5 * 1.8), CFrame.new(0, 0, -5 * 1.8), CFrame.new(0, 0.15, -5 * 1.8),
	CFrame.new(0, 0, -5 * 1.8), CFrame.new(0, 0, -5 * 1.8) * CFrame.Angles(0,0, math.rad(15)), CFrame.new(0, 0, -5 * 1.8) * CFrame.Angles(0,0, math.rad(15)), 
	CFrame.new(0, 0, -5 * 1.8) * CFrame.Angles(0,0, math.rad(-15)), CFrame.new(0, 0, -5 * 1.8) * CFrame.Angles(0,0, math.rad(-15)), CFrame.new(0, 0, -5 * 1.8)  *  CFrame.Angles(math.rad(10),math.rad(-180),math.rad(-5)), CFrame.new(0, 0 , -5 * 1.8)  * CFrame.Angles(math.rad(10),math.rad(7200),math.rad(-5)),
	CFrame.new(0, 0, -5 * 1.8)  *  CFrame.Angles(math.rad(10),math.rad(360),math.rad(-5)) }

--[[ Al interpolar de un punto hacia varios puntos, el punto anterior es el comienzo del nuevo]]
--[[ When interpolating from one point to several points, the previous point is the start of the new one]]

local StartPointsCFrames = { CFrame.new(0, 7, -5 * 1.8), EndPointsCFrames[1], EndPointsCFrames[2], 
	EndPointsCFrames[3], EndPointsCFrames[4], EndPointsCFrames[5],
	EndPointsCFrames[6],EndPointsCFrames[7], EndPointsCFrames[8], 
	EndPointsCFrames[9],EndPointsCFrames[10],EndPointsCFrames[11],EndPointsCFrames[12],EndPointsCFrames[13] }

--[[ The adjusted times of each duration between points]]
--[[ Los tiempos ajustados de cada duracion entre puntos]]

local LerpSizeTimes = { 0.15, 0.05, 0.15, 0.05, 0.45,0.5, 0.4 }

--[[ Puntos pero esta vez en vectores, para interpolar el tamaño del huevo]]
--[[ Points but this time in vectors, to interpose the size of the egg]]

local EndSizes = { Vector3.new(1.25,1.25,1.25), Vector3.new(1.25,1.25,1.25), Vector3.new(1.5,1.5,1.5), Vector3.new(1.5,1.5,1.5), Vector3.new(0.5,0.5,0.5), Vector3.new(0.5,0.5,0.5),  Vector3.new(2,2,2) }

local StartSizes = { Vector3.new(1,1,1), EndSizes[1], EndSizes[2], EndSizes[3], EndSizes[4],EndSizes[5],EndSizes[6] }

function ShowEggToPlayer(PetSelectdName, EggName)

	if HumanoidDead then return end

	EggSystemGui.Enabled = true

	local EggsMeshsCharacter: Folder = Character:FindFirstChild("EggsMeshs")--[[ Se obtiene la carpeta contenedora del Modelo del Huevo]] --[[ Get the Egg Model containing folder]]

	local EggMesh: Model = EggsMeshsCharacter:WaitForChild(EggName)--[[Referencia del huevo]] --[[Egg reference]]

	local EffectMesh: MeshPart = EggMesh:WaitForChild("EffectMesh") --[[Su respectivo effecto, que es una meshpart mas efectos de particulas]]--[[Its respective effect, which is a meshpart plus particle effects]]

	local ElectricParticles = EffectMesh:GetChildren() --[[ Se obtiene una lista con los efectos de particulas]]--[[ Get a list of particle effects]]

	local PetsFolder: Folder = Player:FindFirstChild("PlayerPets") --[[Se obtiene el modelo del Pet]]--[[The model of the Pet is obtained]]

	local Pet1: Model = PetsFolder:FindFirstChild(PetSelectdName) --[[Se obtiene el pet aleatorio que ya fue entregado desde otro script, para asegurar que el jugador tenga su pet encaso de desconexion en medio de la animacion]]--[[Get the random pet that was already delivered from another script, to ensure that the player has his pet in case of disconnection in the middle of the animation]]

	local StartTime = time() --[[Se establece un tiempo Inicial para ir recorriendo la tabla de LerpTimes e ir cambiando entre indice de interpolacion]]
	--[[An Initial time is established to go through the LerpTimes table and change between interpolation indices]]

	local NextIndx = 1

	local NextIndxSizes = 1 

	local StartTimeSize = 0

	local StartSizePrimaryPart = EggMesh.PrimaryPart.Size

	local StartSizeEffectMesh = EffectMesh.Size
	
	--[[ Utilize RenderStepped porque fue la mantuvo el huevo mas fluidamente entre Frames, 
	Stepped y HeartBeat generan pequeños errores de delay y crean pertuberancias y por tanto no es una animacion limpia.
	
	PRIMERA ANIMACION: "Huevo cae, rebota , aparece efecto y explota"]]
	--[[ I used RenderStepped because it kept the egg going more smoothly between Frames,
Stepped and HeartBeat generate small delay errors and create glitches and therefore it is not a clean animation.

FIRST ANIMATION: "Egg falls, bounces, effect appears and explodes"]]
	
	RenderSteppedConnection = RunService.RenderStepped:Connect(function(deltaTime)

		local CurrentTime = time() - StartTime

		local Alpha = CurrentTime / LerpTimes[NextIndx]

		local TargetCFrame = StartPointsCFrames[NextIndx]:Lerp(EndPointsCFrames[NextIndx], Alpha) 

		if Alpha <= 1 and NextIndx == 13 then

			EggMesh:PivotTo(Camera.CFrame * TargetCFrame * CFrame.new(0, 0.05 * math.sin(time() * 22.2 * math.pi * 2),0) )

		else

			EggMesh:PivotTo(Camera.CFrame * TargetCFrame)

		end

		if Alpha >= 1 and NextIndx < 14 then

			NextIndx += 1

			Alpha = 0

			StartTime = time()

		end

		if NextIndx ==  7 and EffectMesh.Transparency == 1 then

			for _, Particle in pairs(ElectricParticles) do

				Particle.Enabled = true

			end

			EffectMesh.Transparency = 0.7

		end

		if NextIndx >= 8 and NextIndxSizes <= 7 then

			if StartTimeSize == 0 then

				StartTimeSize = time()

			end

			local CurrentTimeSize = time() - StartTimeSize

			local AlphaSize = CurrentTimeSize / LerpSizeTimes[NextIndxSizes]

			local TargetSize = StartSizes[NextIndxSizes]:Lerp(EndSizes[NextIndxSizes], AlphaSize)

			for _, Part in pairs(EggMesh:GetChildren()) do

				if Part.Name == "EffectMesh" then

					Part.Size = StartSizeEffectMesh * TargetSize 

				else

					Part.Size = StartSizePrimaryPart * TargetSize

				end

			end

			if AlphaSize >= 1 then

				AlphaSize = 0

				NextIndxSizes += 1

				StartTimeSize = time()

			end

		end

		if Alpha >= 0.5 and NextIndx == 14 then

			RenderSteppedConnection:Disconnect()

			EggMesh:Destroy()


		end

	end)
	
	--[[Se espera a destruir el huevo para seguir con la animacion,
	Se habilitaran las guis que mantendran modelos de los pets o en este caso solo del pet
	y se clona para destruir un clon del pet y no el que fue entregado al usuario]]

--[[Waiting to destroy the egg to continue with the animation,
The guis that will maintain models of the pets or in this case only of the pet will be enabled
and it is cloned to destroy a clone of the pet and not the one that was given to the user]]
	
	EggMesh.Destroying:Wait()

	FlasGui.Enabled = true

	DisplayFrame.Visible = true

	TextLabelPetName.Visible = true

	TextLabelPetName.Text = Pet1.Name

	local PetCloned1: Model = Pet1:Clone()
	PetCloned1.Parent = Camera.Parent
	local AttForParticle = Instance.new("Attachment", PetCloned1.PrimaryPart)
	local MagicOpenSkyBlueParticleCloned = MagicOpenSkyBlueParticle:Clone()
	local MagicOpenYellowParticleCloned = MagicOpenYellowParticle:Clone()
	MagicOpenYellowParticleCloned.Parent = AttForParticle
	MagicOpenSkyBlueParticleCloned.Parent = AttForParticle

	for _, Parts in pairs(PetCloned1:GetChildren()) do

		if Parts:IsA("BasePart") or Parts:IsA("MeshPart") then

			Parts.CanCollide = false
			Parts.Anchored = true
			Parts.CastShadow = false

		end

	end
	--[[Se activan las particulas]]

	--[[Particles are activated]]
	MagicOpenYellowParticleCloned:Emit(40)	
	MagicOpenSkyBlueParticleCloned:Emit(40)
--[[Los puntos que moveran al pet, los cuales lo mantendran quieto y moveran hacia abajo , tambien se ajusta el angulo para mantenerlo
alfrente de la camara]]
	--[[The points that moved the pet, which will stay still and move down, also adjust the angle to keep it
in front of the camera]]
	local EndCFramesPet = { CFrame.new(0,0 ,-PetCloned1.PrimaryPart.Size.Z * 3) * CFrame.Angles(math.rad(0),math.rad(-180),0), CFrame.new(0,-8 ,-PetCloned1.PrimaryPart.Size.Z * 3) * CFrame.Angles(math.rad(0),math.rad(-180),0) }

	local StartCFramesPet = { CFrame.new(0,0 ,-PetCloned1.PrimaryPart.Size.Z * 3) * CFrame.Angles(math.rad(0),math.rad(-180),0), EndCFramesPet[1] }

	local LerpTimesPet = { 2, 1 }

	local NextIndxPet = 1

	StartTime = time()
	--[[Animacion del Pet]]
	--[[Pet animation]]
	RenderSteppedConnection = RunService.RenderStepped:Connect(function(deltaTime)

		local CurrentTime = time() - StartTime

		local Alpha = CurrentTime / LerpTimesPet[NextIndxPet]

		local TargetCFrame = StartCFramesPet[NextIndxPet]:Lerp(EndCFramesPet[NextIndxPet], Alpha)		

		PetCloned1:PivotTo(Camera.CFrame * TargetCFrame)

		if Alpha <= 1 and NextIndxPet == 1 then

			FlashFrame.BackgroundTransparency = math.clamp(Alpha,0,1)

		end	

		if Alpha >= 1 and NextIndxPet <= 1 then

			Alpha = 0

			NextIndxPet += 1

			StartTime = time()

			TextLabelPetName.Visible = false

		end

		if Alpha >= 1 and NextIndxPet == 2 then

			RenderSteppedConnection:Disconnect()

			PetCloned1:Destroy()		

		end



	end)
--[[Se destruye el Pet y se ocultan las Screen Gui y el Viewport, tambien se activa eventos que manejan debounces para poder comprar el pet
y no interrumpir la animacion en ejecucion]]
	--[[The pet is destroyed and the Gui screen and Viewport are hidden, also the events that handle the bounces are triggered to be able to buy the pet.
and not interrupt the running animation]]
	PetCloned1.Destroying:Wait()

	FlashFrame.BackgroundTransparency = 1

	FlasGui.Enabled = false

	EggSystemGui.Enabled = false

	DisplayFrame.Visible = false

	FinishedBuyBindableEvent:Fire()

	FinishedBuyRemoveEvent:FireServer()

end

function ShowThreeEggsToPlayer(PetSelectdName, PetSelectdName2, PetSelectdName3, EggModelName)

	if HumanoidDead then return end

	EggSystemGui.Enabled = true

	local EggsMeshsCharacter: Folder = Character:FindFirstChild("EggsMeshs")

	local EggMesh: Model = EggsMeshsCharacter:GetChildren()[1]

	local EggMesh2: Model = EggsMeshsCharacter:GetChildren()[2]

	local EggMesh3: Model = EggsMeshsCharacter:GetChildren()[3]

	local EffectMesh: MeshPart = EggMesh:WaitForChild("EffectMesh")

	local EffectMesh2: MeshPart = EggMesh2:WaitForChild("EffectMesh")

	local EffectMesh3: MeshPart = EggMesh3:WaitForChild("EffectMesh")

	local ElectricParticles = EffectMesh:GetChildren()

	local ElectricParticles2 = EffectMesh2:GetChildren()

	local ElectricParticles3 = EffectMesh3:GetChildren()

	local PetsFolder: Folder = Player:FindFirstChild("PlayerPets")

	local Pet1: Model = PetsFolder:FindFirstChild(PetSelectdName)

	local Pet2: Model = PetsFolder:FindFirstChild(PetSelectdName2)

	local Pet3: Model = PetsFolder:FindFirstChild(PetSelectdName3)

	local StartTime = time()

	local NextIndx = 1

	local NextIndxSizes = 1 

	local StartTimeSize = 0

	local StartSizePrimaryPart = EggMesh.PrimaryPart.Size

	local StartSizeEffectMesh = EffectMesh.Size

	RenderSteppedConnection = RunService.RenderStepped:Connect(function(deltaTime)

		local CurrentTime = time() - StartTime

		local Alpha = CurrentTime / LerpTimes[NextIndx]

		local TargetCFrame = StartPointsCFrames[NextIndx]:Lerp(EndPointsCFrames[NextIndx], Alpha) 

		local TargetCFrame = StartPointsCFrames[NextIndx]:Lerp(EndPointsCFrames[NextIndx], Alpha)

		local TargetCFrame = StartPointsCFrames[NextIndx]:Lerp(EndPointsCFrames[NextIndx], Alpha)

		if Alpha <= 1 and NextIndx == 13 then

			EggMesh:PivotTo(Camera.CFrame * TargetCFrame * CFrame.new(0, 0.05 * math.sin(time() * 22.2 * math.pi * 2),0) )

			EggMesh2:PivotTo(Camera.CFrame * CFrame.new(5,0,0) * TargetCFrame * CFrame.new(0, 0.05 * math.sin(time() * 22.2 * math.pi * 2),0))

			EggMesh3:PivotTo(Camera.CFrame * CFrame.new(-5,0,0) * TargetCFrame * CFrame.new(0, 0.05 * math.sin(time() * 22.2 * math.pi * 2),0) )

		else

			EggMesh:PivotTo(Camera.CFrame * TargetCFrame)

			EggMesh2:PivotTo(Camera.CFrame * CFrame.new(5,0,0) * TargetCFrame)

			EggMesh3:PivotTo(Camera.CFrame * CFrame.new(-5,0,0) * TargetCFrame)

		end

		if Alpha >= 1 and NextIndx < 14 then

			NextIndx += 1

			Alpha = 0

			StartTime = time()

		end

		if NextIndx ==  7 and EffectMesh.Transparency == 1 then

			for _, Particle in pairs(ElectricParticles) do

				Particle.Enabled = true

			end

			EffectMesh.Transparency = 0.7

			for _, Particle in pairs(ElectricParticles2) do

				Particle.Enabled = true

			end

			EffectMesh2.Transparency = 0.7

			for _, Particle in pairs(ElectricParticles3) do

				Particle.Enabled = true

			end

			EffectMesh3.Transparency = 0.7

		end

		if NextIndx >= 8 and NextIndxSizes <= 7 then

			if StartTimeSize == 0 then

				StartTimeSize = time()

			end

			local CurrentTimeSize = time() - StartTimeSize

			local AlphaSize = CurrentTimeSize / LerpSizeTimes[NextIndxSizes]

			local TargetSize = StartSizes[NextIndxSizes]:Lerp(EndSizes[NextIndxSizes], AlphaSize)

			for _, Part in pairs(EggMesh:GetChildren()) do

				if Part.Name == "EffectMesh" then

					Part.Size = StartSizeEffectMesh * TargetSize 

				else

					Part.Size = StartSizePrimaryPart * TargetSize

				end

			end

			for _, Part in pairs(EggMesh2:GetChildren()) do

				if Part.Name == "EffectMesh" then

					Part.Size = StartSizeEffectMesh * TargetSize 

				else

					Part.Size = StartSizePrimaryPart * TargetSize

				end

			end

			for _, Part in pairs(EggMesh3:GetChildren()) do

				if Part.Name == "EffectMesh" then

					Part.Size = StartSizeEffectMesh * TargetSize 

				else

					Part.Size = StartSizePrimaryPart * TargetSize

				end

			end

			if AlphaSize >= 1 then

				AlphaSize = 0

				NextIndxSizes += 1

				StartTimeSize = time()

			end

		end

		if Alpha >= 0.5 and NextIndx == 14 then

			RenderSteppedConnection:Disconnect()

			EggMesh:Destroy()

			EggMesh2:Destroy()

			EggMesh3:Destroy()


		end

	end)

	EggMesh.Destroying:Wait()

	FlasGui.Enabled = true

	DisplayFrame.Visible = true

	DisplayFrame2.Visible = true

	DisplayFrame3.Visible = true

	TextLabelPetName.Visible = true

	TextLabelPetName.Text = PetSelectdName

	TextLabelPetName2.Visible = true

	TextLabelPetName2.Text = PetSelectdName2

	TextLabelPetName3.Visible = true

	TextLabelPetName3.Text = PetSelectdName3


	local PetCloned1: Model = Pet1:Clone()
	PetCloned1.Parent = Camera.Parent
	local AttForParticle = Instance.new("Attachment", PetCloned1.PrimaryPart)
	local MagicOpenSkyBlueParticleCloned = MagicOpenSkyBlueParticle:Clone()
	local MagicOpenYellowParticleCloned = MagicOpenYellowParticle:Clone()
	MagicOpenYellowParticleCloned.Parent = AttForParticle
	MagicOpenSkyBlueParticleCloned.Parent = AttForParticle

	local PetCloned2: Model = Pet2:Clone()
	PetCloned2.Parent = Camera.Parent
	local AttForParticle2 = Instance.new("Attachment", PetCloned2.PrimaryPart)
	local MagicOpenSkyBlueParticleCloned2 = MagicOpenSkyBlueParticle:Clone()
	local MagicOpenYellowParticleCloned2 = MagicOpenYellowParticle:Clone()
	MagicOpenYellowParticleCloned2.Parent = AttForParticle2
	MagicOpenSkyBlueParticleCloned2.Parent = AttForParticle2


	local PetCloned3: Model = Pet3:Clone()
	PetCloned3.Parent = Camera.Parent
	local AttForParticle3 = Instance.new("Attachment", PetCloned3.PrimaryPart)
	local MagicOpenSkyBlueParticleCloned3 = MagicOpenSkyBlueParticle:Clone()
	local MagicOpenYellowParticleCloned3 = MagicOpenYellowParticle:Clone()
	MagicOpenYellowParticleCloned3.Parent = AttForParticle3
	MagicOpenSkyBlueParticleCloned3.Parent = AttForParticle3

	for _, Parts in pairs(PetCloned1:GetChildren()) do

		if Parts:IsA("BasePart") or Parts:IsA("MeshPart") then

			Parts.CanCollide = false
			Parts.Anchored = true
			Parts.CastShadow = false

		end

	end

	for _, Parts in pairs(PetCloned2:GetChildren()) do

		if Parts:IsA("BasePart") or Parts:IsA("MeshPart") then

			Parts.CanCollide = false
			Parts.Anchored = true
			Parts.CastShadow = false

		end

	end

	for _, Parts in pairs(PetCloned3:GetChildren()) do

		if Parts:IsA("BasePart") or Parts:IsA("MeshPart") then

			Parts.CanCollide = false
			Parts.Anchored = true
			Parts.CastShadow = false

		end

	end

	MagicOpenYellowParticleCloned:Emit(40)
	MagicOpenSkyBlueParticleCloned:Emit(40)
	MagicOpenYellowParticleCloned2:Emit(40)
	MagicOpenSkyBlueParticleCloned2:Emit(40)
	MagicOpenYellowParticleCloned3:Emit(40)
	MagicOpenSkyBlueParticleCloned3:Emit(40)

	local EndCFramesPet = { CFrame.new(0,0 , -4 * 2.5) * CFrame.Angles(math.rad(0),math.rad(-180),0), CFrame.new(0,-8 ,-4 * 2.5) * CFrame.Angles(math.rad(0),math.rad(-180),0) }

	local StartCFramesPet = { CFrame.new(0,0 ,-4 * 2.5) * CFrame.Angles(math.rad(0),math.rad(-180),0), EndCFramesPet[1] }

	local LerpTimesPet = { 2, 1 }

	local NextIndxPet = 1

	StartTime = time()

	RenderSteppedConnection = RunService.RenderStepped:Connect(function(deltaTime)

		local CurrentTime = time() - StartTime

		local Alpha = CurrentTime / LerpTimesPet[NextIndxPet]

		local TargetCFrame = StartCFramesPet[NextIndxPet]:Lerp(EndCFramesPet[NextIndxPet], Alpha)		

		PetCloned1:PivotTo(Camera.CFrame * TargetCFrame)

		PetCloned2:PivotTo(Camera.CFrame * CFrame.new(8,0,0) * TargetCFrame * CFrame.Angles(0,math.rad(-15),0))

		PetCloned3:PivotTo(Camera.CFrame * CFrame.new(-8,0,0) * TargetCFrame * CFrame.Angles(0,math.rad(15),0))

		if Alpha <= 1 and NextIndxPet == 1 then

			FlashFrame.BackgroundTransparency = math.clamp(Alpha,0,1)

		end	

		if Alpha >= 1 and NextIndxPet <= 1 then

			Alpha = 0

			NextIndxPet += 1

			StartTime = time()

			TextLabelPetName.Visible = false

			TextLabelPetName2.Visible = false

			TextLabelPetName3.Visible = false

		end

		if Alpha >= 1 and NextIndxPet == 2 then

			RenderSteppedConnection:Disconnect()

			PetCloned1:Destroy()	

			PetCloned2:Destroy()

			PetCloned3:Destroy()

		end



	end)

	PetCloned1.Destroying:Wait()

	FlashFrame.BackgroundTransparency = 1

	FlasGui.Enabled = false

	EggSystemGui.Enabled = false

	DisplayFrame.Visible = false

	DisplayFrame2.Visible = false

	DisplayFrame3.Visible = false

	TextLabelPetName.Visible = false

	TextLabelPetName2.Visible = false

	TextLabelPetName3.Visible = false

	FinishedBuyBindableEvent:Fire()

	FinishedBuyRemoveEvent:FireServer()

end

PurchasedNowShowEggConnection = PurchasedNowShowEgg2RemoteEvent.OnClientEvent:Connect(ShowEggToPlayer)


PurchasedNowShowThirdEggsRemoveEventConnection = PurchasedNowShowThirdEggsRemoveEvent.OnClientEvent:Connect(ShowThreeEggsToPlayer)


--[[ Los eventos "PurchasedNowShowEgg2RemoteEvent" y "PurchasedNowShowThirdEggsRemoveEvent", activan la animacion correspondiente ya sea
que el jugador compro 1 pet o 3.]]
--[[ 
--[[ The "PurchasedNowShowEgg2RemoteEvent" and "PurchasedNowShowThirdEggsRemoveEvent" events trigger the corresponding animation either
that the player commits 1 pet or 3.]]]]
