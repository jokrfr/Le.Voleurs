ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local new           = false
local k             = 270.0
local FirstSpawn    = true
local PlayerLoaded  = false
local cam
local PlayerData = {}

local scaleform = {}
local text = {}
local signmodel = GetHashKey("prop_police_id_board")
local textmodel = GetHashKey("prop_police_id_text")


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

--[[RegisterCommand("+V_Spawn", function(data)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin == nil then
			V_CoreChar()
		else
			V_CoreChar()
		end
    end)
end)]]

RegisterNetEvent('Val:CharCreator')
AddEventHandler('Val:CharCreator', function()
	V_CoreChar()
end)

function V_CoreChar()
	enable = true
	ESX.UI.HUD.SetDisplay(0.0)
	DisplayRadar(false)
	Spawn()
end

TriggerEvent('instance:registerType', 'creationperso')
RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
    if instance.type == 'creationperso' then
        TriggerEvent('instance:enter', instance)
    end
end)

local Enabled = true
local FaceCam = false

function Spawn()
	
	TriggerEvent('instance:create', 'creationperso', IDa, {instance = IDa, owner = GetPlayerServerId(PlayerId())})
	
	local function func_1636 (cam, f1, f2, f3, f4)
		N_0xf55e4046f6f831dc(cam, f1)
		N_0xe111a7c0d200cbc5(cam, f2)
		SetCamDofFnumberOfLens(cam, f3)
		SetCamDofMaxNearInFocusDistanceBlendLevel(cam, f4)
	end
	
	DoScreenFadeOut(1000)
	Wait(1000)
	TriggerEvent('BlockKey')
	SetOverrideWeather("EXTRASUNNY")
    SetWeatherTypePersist("EXTRASUNNY")
    NetworkOverrideClockTime(16, 0, 0)
    local IDa = math.random(10000, 90000)
	DoScreenFadeOut(1000)
	Wait(1000) 
	local playerPed = PlayerPedId()
    Citizen.Wait(2000) 
	DestroyAllCams(true)
	DoScreenFadeOut(0)
	cam3 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
	SetCamCoord(cam3, 473.75, -1011.72, 27.01)
	SetCamFov(cam3, 60.97171)
	ShakeCam(cam3, "HAND_SHAKE", 0.1)
	func_1636(cam3, 7.2, 1.0, 0.5, 1.0)
    SetCamActive(cam3, true)
	RenderScriptCams(true, false, 2000, true, true) 
	cam5 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
	SetCamCoord(cam5, 473.59, -1013.18, 26.75) 
	SetCamFov(cam5, 60.00)
	DoScreenFadeIn(2000)
	IntoLeV()
	TriggerEvent("ShowBienvenue")
    Citizen.Wait(500)
	PlaySoundFrontend(-1, "Lights_On", "GTAO_MUGSHOT_ROOM_SOUNDS", true)
	SetEntityCoords(GetPlayerPed(-1), 476.22, -1011.59, 26.27, 0.0, 0.0, 0.0, true)
	SetEntityHeading(GetPlayerPed(-1), 91.11)
    changeGender(1)
    Citizen.Wait(500)
	LoadAnim("mp_character_creation@customise@male_a")
	print("Joue l'anim")
    TaskPlayAnim(GetPlayerPed(-1), "mp_character_creation@customise@male_a", "intro", 1.0, 1.0, 4000, 0, 1, 0, 0, 0)
    Citizen.Wait(5000)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    if GetDistanceBetweenCoords(coords, 473.61, -1011.46, 26.27, true) > 0.5 then
    	SetEntityCoords(GetPlayerPed(-1), 473.61, -1011.46, 26.27, 0.0, 0.0, 0.0, true)
    	SetEntityHeading(GetPlayerPed(-1), 183.97)
    end
	Citizen.Wait(100)
	RageUI.Visible(RMenu:Get('Le.V', 'Creator'), true)
    MenuCreator()
    Citizen.Wait(1000)
	FreezeEntityPosition(GetPlayerPed(-1), true)
	cam4 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false) 
	SetCamCoord(cam4, 473.57, -1012.16, 26.80) 
	SetCamFov(cam4, 80.00)
end

function IntoLeV()

	if DoesCamExist(cam5) then
		StopCamShaking(cam5)
		SetCamActiveWithInterp(cam5, cam3, 5000, 1, 1)
	end
	
end

Character = {}
ClotheList = {}
local enable = true

local playerPed = PlayerPedId()
local incamera = false
local handle
local isinintroduction = false
local pressedenter = false
local introstep = 0
local timer = 0
local inputgroups = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31}
local enanimcinematique = false
local guiEnabled = false


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- Apparence modification
local pedModel = 'mp_m_freemode_01'
function changeGender(sex)
	if sex == 1 then
		Character['sex'] = 0
		pedModel = 'mp_m_freemode_01'
		changeModel(pedModel)
	else
		Character['sex'] = 1
		pedModel = 'mp_f_freemode_01'
		changeModel(pedModel)
	end
end

function changeModel(skin)
	local model = GetHashKey(skin)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())

        if skin == 'mp_m_freemode_01' then
            SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2) -- arms
            SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 2) -- torso
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) -- tshirt
            SetPedComponentVariation(GetPlayerPed(-1), 4, 61, 4, 2) -- pants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 2) -- shoes

            Character['arms'] = 15
            Character['torso_1'] = 15
            Character['tshirt_1'] = 15
            Character['pants_1'] = 61
            Character['pants_2'] = 4
            Character['shoes_1'] = 34
            Character['glasses_1'] = 0


        elseif skin == 'mp_f_freemode_01' then
            SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2) -- arms
            SetPedComponentVariation(GetPlayerPed(-1), 11, 5, 0, 2) -- torso
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) -- tshirt
            SetPedComponentVariation(GetPlayerPed(-1), 4, 57, 0, 2) -- pants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 35, 0, 2) -- shoes

            Character['arms'] = 15
            Character['torso_1'] = 5
            Character['tshirt_1'] = 15
            Character['pants_1'] = 57
            Character['pants_2'] = 0
            Character['shoes_1'] = 35
            Character['glasses_1'] = -1
        end


        SetModelAsNoLongerNeeded(model)
    end
end

Apperance = {
	{
		item = 'hair',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'component',
		itemID = 2,
		PercentagePanel = false,
		ColourPanel = true,
	},
	{
		item = 'eyebrows',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 2,
		PercentagePanel = true,
		ColourPanel = true,
	},
	{
		item = 'beard',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 1,
		PercentagePanel = true,
		ColourPanel = true,
	},
	{
		item = 'bodyb',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
		index = 1,
		indextwo = 1,
		cam = 'body',
		itemType = 'headoverlay',
		itemID = 11,
		PercentagePanel = true,
	},
	{
		item = 'age',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 3,
		PercentagePanel = true,
	},
	{
		item = 'blemishes',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 0,
		PercentagePanel = true,
	},
	{
		item = 'moles',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 9,
		PercentagePanel = true,
	},
	{
		item = 'sun',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 7,
		PercentagePanel = true,
	},
	{
		item = 'eyes_color',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'eye'
	},
	{
		item = 'makeup',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 4,
		PercentagePanel = true,
		ColourPanel = true,
	},
	{
		item = 'lipstick',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 8,
		PercentagePanel = true,
		ColourPanel = true,
	},
	{
		item = 'chest',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16},
		index = 1,
		indextwo = 1,
		cam = 'body',
		itemType = 'headoverlay',
		itemID = 10,
		PercentagePanel = true,
		ColourPanel = true,
	},
	{
		item = 'blush',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 5,
		PercentagePanel = true,
		ColourPanel = true,
	},
}

function updateApperance(id, color)
	local app = Apperance[id]
	local playerPed = PlayerPedId()
	if not color then
		if app.itemType == 'component' then
			SetPedComponentVariation(playerPed, app.itemID, app.index, 0, 2)
			Character[app.item..'_1'] = app.index
	    elseif app.itemType == 'headoverlay' then
			SetPedHeadOverlay(playerPed, app.itemID, app.index, math.floor(app.indextwo)/10+0.0)
			Character[app.item..'_1'] = app.index
			Character[app.item..'_2'] = math.floor(app.indextwo)
	    elseif app.itemType == 'eye' then
			SetPedEyeColor(playerPed, app.index, 0, 1)
			Character['eye_color'] = app.index
	    end
	end

    if color then
    	if app.itemType == 'component' then
            SetPedHairColor(playerPed, app.indextwo, 0)
            Character['hair_color_1'] = app.indextwo
        elseif app.itemType == 'headoverlay' then
            SetPedHeadOverlayColor(playerPed, app.itemID, 1, app.indextwo, 0)
            Character[app.item..'_3'] = app.indextwo
        end
    end	
end

-- Clothe modification
function GenerateClotheList()
	for i=1, #Config.Outfit, 1 do
		table.insert(ClotheList, Config.Outfit[i].label)
	end
end

local ComponentClothe = {tshirt = 8, torso = 11, decals = 10, arms = 3, pants = 4, shoes = 6, chain = 7}
local PropIndexClothe = {helmet = 0, glasses = 1}

function updateClothe(index)
    local clothe = Config.Outfit[index]
    local gender
    if Character['sex'] == 0 then
        gender = 'male'
    else
        gender = 'female'
    end

    local playerPed = PlayerPedId()

    for k,v in pairs(clothe.id[gender]) do
        if k == 'helmet' or k == 'glasses' then
            SetPedPropIndex(playerPed, PropIndexClothe[k], v[1], v[2])
        else
            if k == 'arms' then
            	Character[k] = v[1]
            else
            	Character[k..'_1'] = v[1]
            end
           	Character[k..'_2'] = v[2]
            SetPedComponentVariation(playerPed, ComponentClothe[k], v[1], v[2])
        end
    end
end

Citizen.CreateThread(function()
	RMenu.Add('Le.V', 'Creator', RageUI.CreateMenu("G.~r~M~s~.L", "Création de personnage", nil,75))
	RMenu:Get('Le.V', 'Creator'):SetRectangleBanner(39, 41, 39, 100)
	RMenu:Get('Le.V', 'Creator').Closable = false
	RMenu:Get('Le.V', 'Creator').EnableMouse = true
end)

Panel = {
	GridPanel = {
		x = 0.5,
		y = 0.5,
		Top = Locales[Config.Locale]['top'],
        Bottom = Locales[Config.Locale]['bottom'],
        Left = Locales[Config.Locale]['left'],
        Right = Locales[Config.Locale]['right'],
		enable = false
	},

	GridPanelHorizontal = {
		x = 0.5,
        Left = Locales[Config.Locale]['left'],
        Right = Locales[Config.Locale]['right'],
		enable = false
	},

	ColourPanel = {
		itemIndex = 1,
        index_one = 1,
        index_two = 1,
		name = Locales[Config.Locale]['colour'],
        Color = RageUI.PanelColour.HairCut,
		enable = false
	},

	PercentagePanel = {
		index = 0,
        itemIndex = 1,
        MinText = '0%',
        HeaderText = Locales[Config.Locale]['opacity'],
        MaxText = '100%',
		enable = false
	}
}

function ManagePanel(type, data)
    if data.Top then
    	Panel[type].Top = data.Top
    end

    if data.Bottom then
    	Panel[type].Bottom = data.Bottom
    end

    if data.Left then
    	Panel[type].Left = data.Left
    end

    if data.Right then
    	Panel[type].Right = data.Right
    end

    if data.x then
    	Panel[type].PFF = data.x
    end

    if data.y then
    	Panel[type].PFF2 = data.y
    end

    if type ~= 'ColourPanel' and type ~= 'PercentagePanel' and type ~= '' then

	    if not Panel[type].currentItem then
	        Panel[type].lastItem = data.x[2]
		else
			Panel[type].lastItem = Panel[type].currentItem
		end	
		Panel[type].currentItem = data.x[2]
		if not Panel[type][Panel[type].currentItem] then
			Panel[type][Panel[type].currentItem] = {
				x = 0.5,
				y = 0.5
			}
		end
	end

	if type == 'ColourPanel' or type == 'PercentagePanel' then

		Panel[type].itemIndex = data.index
		if data.Panel then
			Panel[data.Panel].itemIndex = data.index
		end

		if not Panel[type].currentItem then
	        Panel[type].lastItem = data.item
		else
			Panel[type].lastItem = Panel[type].currentItem
		end	
		Panel[type].currentItem = data.item

		if not Panel[type][Panel[type].currentItem] then
			Panel[type][Panel[type].currentItem] = {
				index = type == 'ColourPanel' and 1 or 0,
				minindex = 1
			}
		end

		if data.Panel then
			if not Panel[data.Panel].currentItem then
		        Panel[data.Panel].lastItem = data.item
			else
				Panel[data.Panel].lastItem = Panel[data.Panel].currentItem
			end	
			Panel[data.Panel].currentItem = data.item

			if not Panel[data.Panel][Panel[data.Panel].currentItem] then
				Panel[data.Panel][Panel[data.Panel].currentItem] = {
					index = data.Panel == 'PercentagePanel' and 0 or 1,
					minindex = 1
				}
			end
		end
	end

	for k,v in pairs(Panel) do
		if data.Panel then
			if k == type or k == data.Panel then
				v.enable = true
			else
				v.enable = false
			end
		else
	        if k == type then
	            v.enable = true
	        else
	            v.enable = false
	        end
	    end
    end
end

local sex = {

    "Homme",

    "Femme"

}

local index = {

    ketchup = false;

    dish = 1;

    quantity = 0;

    panel = {

        percentage = 0.5

    },

    colored = { [1] = 1, [2] = 1 }

}

local menu = {
    username = "",
    mdp = "",
}

local char = {Creator = false}


local Percent_ = 0.0
local Percent2_ = 0.0

local actionGender, actionClothe, actionMother, actionFather, actionRessemblance, actionSkin = 1, 1, 1, 1, 5, 5
local CharacterMom, CharacterDad, ShapeMixData, SkinMixData = 1, 1, 0.5, 0.5
local amount = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };

function MenuCreator()
	if char.Creator then
		return
	end
	char.Creator = true
	while char.Creator do
			Wait(1)
			if not RageUI.Visible(RMenu:Get('Le.V', 'Creator')) then
				char.Creator = false
			end
			RageUI.Visible(RMenu:Get('Le.V', 'Creator'), true)

			RageUI.IsVisible(RMenu:Get('Le.V', 'Creator'),true,true,true,function() 

			RageUI.List("Sexe", {"Masculin", "Féminim"}, actionGender, nil, {}, true, function(Hovered, Active, Selected, Index)
			end, function(Index, Item)
				actionGender = Index
				changeGender(Index)
			end)
		
			RageUI.Checkbox("Héritage", nil, Heritage, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked, NomJoueur)
				if Selected and Checked ~= Heritage then
					Heritage = Checked
				end
			end)

				if Heritage then 

					RageUI.CenterButton("‹ ~o~Héritage ~s~ ›", nil, {}, true,function(h,a,s) 
					end)

					RageUI.HeritageWindow(CharacterMom, CharacterDad)
					RageUI.List("Mère", Config.MotherList, actionMother, nil, {}, true, function(hovered,active,selected, Index)
					end, function(Index, Item)
						actionMother = Index
						CharacterMom = Index
						Character['mom'] = Index
						SetPedHeadBlendData(GetPlayerPed(-1), CharacterMom, CharacterDad, nil, CharacterMom, CharacterDad, nil, ShapeMixData, SkinMixData, nil, true)
					end)
					RageUI.List("Père", Config.FatherList, actionFather, nil, {}, true, function(hovered,active,selected, Index)
					end, function(Index, Item)
						actionFather = Index
						CharacterDad = Index
						Character['dad'] = Index
						SetPedHeadBlendData(GetPlayerPed(-1), CharacterMom, CharacterDad, nil, CharacterMom, CharacterDad, nil, ShapeMixData, SkinMixData, nil, true)
					end)
					RageUI.UISliderHeritage("Ressemblance", actionRessemblance, nil, function(Hovered, Selected, Active, Heritage, Index)
						if Selected then
							actionRessemblance = Index
							ShapeMixData = Index/10
							Character['face'] = Index/10
							SetPedHeadBlendData(GetPlayerPed(-1), CharacterMom, CharacterDad, nil, CharacterMom, CharacterDad, nil, ShapeMixData, SkinMixData, nil, true)
						end
					end, amount)
					RageUI.UISliderHeritage("Teint de la peau", actionSkin, nil, function(Hovered, Selected, Active, Heritage, Index)
						if Selected then
							actionSkin = Index
							SkinMixData = Index/10
							Character['skin'] = Index/10
							SetPedHeadBlendData(GetPlayerPed(-1), CharacterMom, CharacterDad, nil, CharacterMom, CharacterDad, nil, ShapeMixData, SkinMixData, nil, true)
						end
					end, amount)
				end

					RageUI.Checkbox("Apparence", nil, Apparence, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked, NomJoueur)
						if Selected and Checked ~= Apparence then
							Apparence = Checked
						end
					end)

				if Apparence then
					RageUI.CenterButton("‹ ~o~Apparence~s~ ›", nil, {}, true,function(h,a,s) 
					end)
					for k,v in ipairs(Apperance) do
						RageUI.List(Locales[Config.Locale][v.item], v.List, v.index, Locales[Config.Locale][v.item..'_desc'], {}, true, function(Hovered, Active, Selected, Index)
							if Active then
								if v.ColourPanel and v.PercentagePanel then
									ManagePanel('ColourPanel', {Panel = 'PercentagePanel', index = k, item = v.item})
								elseif v.ColourPanel and not v.PercentagePanel then
									ManagePanel('ColourPanel', {index = k, item = v.item})
								elseif not v.ColourPanel and v.PercentagePanel then
									ManagePanel('PercentagePanel', {index = k, item = v.item})
								elseif not v.ColourPanel and not v.PercentagePanel then
									ManagePanel('', {})
								end
							end
						end, function(Index, Item)
							v.index = Index
							updateApperance(k)
						end)
					end
					if Panel.ColourPanel.enable then
						RageUI.ColourPanel(Panel.ColourPanel.name, Panel.ColourPanel.Color, Panel.ColourPanel.index_one, Panel.ColourPanel.index_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
							if Panel.ColourPanel.lastItem == Panel.ColourPanel.currentItem then
								Panel.ColourPanel.index_one = MinimumIndex
								Panel.ColourPanel.index_two = CurrentIndex
							else
								Panel.ColourPanel.index_one = Panel.ColourPanel[Panel.ColourPanel.currentItem].minindex
								Panel.ColourPanel.index_two = Panel.ColourPanel[Panel.ColourPanel.currentItem].index
							end

							if Active then
								Panel.ColourPanel[Panel.ColourPanel.currentItem].minindex = MinimumIndex
								Panel.ColourPanel[Panel.ColourPanel.currentItem].index = CurrentIndex

								Apperance[Panel.ColourPanel.itemIndex].indextwo = math.floor(CurrentIndex+0.0)
								updateApperance(Panel.ColourPanel.itemIndex, true, false)
							end
						end)
					end

					if Panel.PercentagePanel.enable then
						RageUI.PercentagePanel(Panel.PercentagePanel.index, Panel.PercentagePanel.HeaderText, Panel.PercentagePanel.MinText, Panel.PercentagePanel.MaxText, function(Hovered, Active, Percent)
							if Panel.PercentagePanel.lastItem == Panel.PercentagePanel.currentItem then
								Panel.PercentagePanel.index = Percent
							else
								Panel.PercentagePanel.index = Panel.PercentagePanel[Panel.PercentagePanel.currentItem].index
							end
							if Active then
								Panel.PercentagePanel[Panel.PercentagePanel.currentItem].index = Percent

								Apperance[Panel.PercentagePanel.itemIndex].indextwo = math.floor(Percent*10)
								updateApperance(Panel.PercentagePanel.itemIndex, false)
							end
						end)
					end
				end

				RageUI.Checkbox("Apparence du visage", nil, ApparenceVis, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked, NomJoueur)
					if Selected and Checked ~= ApparenceVis then
						ApparenceVis = Checked
					end
				end)

			if ApparenceVis then
				
				RageUI.CenterButton("‹ ~o~Apparence du visage~s~ ›", nil, {}, true,function(h,a,s) 
				end)

				RageUI.Button(Locales[Config.Locale]['nose'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanel', {x = {0, 'nose_1'}, y = {1, 'nose_2'}, Top = Locales[Config.Locale]['top'], Bottom = Locales[Config.Locale]['bottom'], Left = Locales[Config.Locale]['narrow'], Right = Locales[Config.Locale]['large']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['profil_nose'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanel', {x = {2, 'nose_3'}, y = {3, 'nose_4'}, Top = Locales[Config.Locale]['curve'], Bottom = Locales[Config.Locale]['curved'], Left = Locales[Config.Locale]['short'], Right = Locales[Config.Locale]['long']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['pointe_nose'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanel', {x = {4, 'nose_5'}, y = {5, 'nose_6'}, Top = Locales[Config.Locale]['broke_left'], Bottom = Locales[Config.Locale]['broke_right'], Left = Locales[Config.Locale]['peak_high'], Right = Locales[Config.Locale]['peak_low']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['eyebrows'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanel', {x = {6, 'eyebrows_5'}, y = {7, 'eyebrows_6'}, Top = Locales[Config.Locale]['top'], Bottom = Locales[Config.Locale]['bottom'], Left = Locales[Config.Locale]['outside'], Right = Locales[Config.Locale]['interior']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['cheekbones'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanel', {x = {9, 'cheeks_1'}, y = {8, 'cheeks_2'}, Top = Locales[Config.Locale]['top'], Bottom = Locales[Config.Locale]['bottom'], Left = Locales[Config.Locale]['dig'], Right = Locales[Config.Locale]['inflate']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['cheek'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanelHorizontal', {x = {10, 'cheeks_3'}, Left = Locales[Config.Locale]['inflate'], Right = Locales[Config.Locale]['dig']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['eyes'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanelHorizontal', {x = {11, 'eye_open'}, Left = Locales[Config.Locale]['opened_eyes'], Right = Locales[Config.Locale]['narrowed_eyes']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['lips'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanelHorizontal', {x = {12, 'lips_thick'}, Left = Locales[Config.Locale]['thick'], Right = Locales[Config.Locale]['thin']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['jaw'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanel', {x = {13, 'jaw_1'}, y = {14, 'jaw_2'}, Top = Locales[Config.Locale]['round'], Bottom = Locales[Config.Locale]['square'], Left = Locales[Config.Locale]['narrow'], Right = Locales[Config.Locale]['large']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['chin'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanel', {x = {15, 'chin_height'}, y = {16, 'chin_lenght'}, Top = Locales[Config.Locale]['top'], Bottom = Locales[Config.Locale]['bottom'], Left = Locales[Config.Locale]['deep'], Right = Locales[Config.Locale]['outside']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['shape_chin'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanel', {x = {17, 'chin_width'}, y = {18, 'chin_hole'}, Top = Locales[Config.Locale]['sharp'], Bottom = Locales[Config.Locale]['bum'], Left = Locales[Config.Locale]['round'], Right = Locales[Config.Locale]['square']})
					end
				end)

				RageUI.Button(Locales[Config.Locale]['neck_thickness'], false, {}, true, function(Hovered, Active, Selected)
					if Active then
						ManagePanel('GridPanelHorizontal', {x = {19, 'neck_thick'}, Left = Locales[Config.Locale]['thin'], Right = Locales[Config.Locale]['thick']})
					end
				end)

				if Panel.GridPanel.enable then
					RageUI.GridPanel(Panel.GridPanel.x, Panel.GridPanel.y, Panel.GridPanel.Top, Panel.GridPanel.Bottom, Panel.GridPanel.Left, Panel.GridPanel.Right, function(Hovered, Active, X, Y)
						if Panel.GridPanel.lastItem == Panel.GridPanel.currentItem then
							Panel.GridPanel.x = X
							Panel.GridPanel.y = Y
						else
							Panel.GridPanel.x = Panel.GridPanel[Panel.GridPanel.currentItem].x
							Panel.GridPanel.y = Panel.GridPanel[Panel.GridPanel.currentItem].y
						end
	
	
						if Active then
							Panel.GridPanel[Panel.GridPanel.currentItem].x = X
							Panel.GridPanel[Panel.GridPanel.currentItem].y = Y
	
							SetPedFaceFeature(GetPlayerPed(-1), Panel.GridPanel.PFF[1], X)
							SetPedFaceFeature(GetPlayerPed(-1), Panel.GridPanel.PFF2[1], Y)
	
							Character[Panel.GridPanel.PFF[2]] = X
							Character[Panel.GridPanel.PFF2[2]] = Y
						end
					end)
				end
	
				if Panel.GridPanelHorizontal.enable then
					RageUI.GridPanelHorizontal(Panel.GridPanelHorizontal.x, Panel.GridPanelHorizontal.Left, Panel.GridPanelHorizontal.Right, function(Hovered, Active, X)
						if Panel.GridPanelHorizontal.lastItem == Panel.GridPanelHorizontal.currentItem then
							Panel.GridPanelHorizontal.x = X
						else
							Panel.GridPanelHorizontal.x = Panel.GridPanelHorizontal[Panel.GridPanelHorizontal.currentItem].x
						end
						if Active then
							Panel.GridPanelHorizontal[Panel.GridPanelHorizontal.currentItem].x = X
							SetPedFaceFeature(GetPlayerPed(-1), Panel.GridPanelHorizontal.PFF[1], X)
							Character[Panel.GridPanelHorizontal.PFF[2]] = X
						end
					end)
				end

			end
		end)
	end
end


local scaleformWorld = {
	{
		model = "bkr_prop_rt_clubhouse_table", scaleform = "BIKER_MISSION_WALL", rendertarget = "clubhouse_table",
		data = {
		},
		height = .9, width = 0.9, x = 0.55, y = 0.5,
	},
}

function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end

	return handle
end

local function SetOrganisationName()
	local ped = GetPlayerPed(-1)
	local plyPos = GetEntityCoords(ped)

	for k,v in pairs(scaleformWorld) do
		if v.shouldDraw and v.shouldDraw(ped, plyPos) then
			local targetHash = GetHashKey(v.model)
			v.banner = RequestScaleformMovie(v.scaleform)

			if (not IsNamedRendertargetRegistered(v.rendertarget)) then
				RegisterNamedRendertarget(v.rendertarget, 0)
				LinkNamedRendertarget(targetHash)

				Citizen.Wait(500)

				if (not IsNamedRendertargetLinked(targetHash)) then
					ReleaseNamedRendertarget(targetHash)
				end
			end

			if HasScaleformMovieLoaded(v.banner) then
				for _,p in pairs(v.data) do
					PushScaleformMovieFunction(v.banner, p.name)
					if p.param then
						for _,par in pairs(p.param) do
							local varType = type(par)
							if varType == "number" then
								if math.type(par) == "integer" then
									PushScaleformMovieFunctionParameterInt(par)
								else
									PushScaleformMovieFunctionParameterFloat(par)
								end
							elseif varType == "boolean" then
								PushScaleformMovieFunctionParameterBool(par)
							elseif varType == "string" then
								PushScaleformMovieFunctionParameterString(par)
							end
						end
					end
					if v.func then v.func() end
					PopScaleformMovieFunction()
				end
			end

			local renderID = GetNamedRendertargetRenderId(v.rendertarget)
			SetTextRenderId(renderID)
			DrawScaleformMovie(v.banner, v.x, v.y, v.width, v.height, 255, 255, 255, 255, 0)
			SetTextRenderId(GetDefaultScriptRendertargetRenderId())
		elseif v.banner then
			SetScaleformMovieAsNoLongerNeeded(v.banner)
			v.banner = nil
		end
	end
end

--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(0)
--		SetOrganisationName()
--	end
--end)

function GetScaleformMenuInfo(scaleform)
	PushScaleformMovieFunction(scaleform, "GET_CURRENT_SCREEN_ID")
	local a = EndScaleformMovieMethodReturn()
	while not GetScaleformMovieFunctionReturnBool(a) do
		Citizen.Wait(0)
	end

	local screenID = GetScaleformMovieFunctionReturnInt(a)

	PushScaleformMovieFunction(scaleform, "GET_CURRENT_SELECTION")
	a = EndScaleformMovieMethodReturn()
	while not GetScaleformMovieFunctionReturnBool(a) do
		Citizen.Wait(0)
	end

	local selectinID = GetScaleformMovieFunctionReturnInt(a)

	return screenID, selectinID
end

function SetScaleformParams(scaleform, data)
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end

function createScaleform(name, data)
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end

--[[
	NICE CINEMATIQUE
]]--

AddEventHandler("Val:End", function()
	local function LoadScaleform (scaleform)
		local handle = RequestScaleformMovie(scaleform)

		if handle ~= 0 then
			while not HasScaleformMovieLoaded(handle) do
				Citizen.Wait(0)
			end
		end

		return handle
	end

	local function CallScaleformMethod (scaleform, method, ...)
		local t
		local args = { ... }

		BeginScaleformMovieMethod(scaleform, method)

		for k, v in ipairs(args) do
			t = type(v)
			if t == 'string' then
				PushScaleformMovieMethodParameterString(v)
			elseif t == 'number' then
				if string.match(tostring(v), "%.") then
					PushScaleformMovieFunctionParameterFloat(v)
				else
					PushScaleformMovieFunctionParameterInt(v)
				end
			elseif t == 'boolean' then
				PushScaleformMovieMethodParameterBool(v)
			end
		end

		EndScaleformMovieMethod()
	end

	local interior_pos = vector3(477.36, -1003.57, 26.27)
	local room = 2086940140 -- mugshot room
	local lineup_male = "mp_character_creation@lineup@male_a"

	local handle
	local board
	local board_model = GetHashKey("prop_police_id_board")
	local board_pos = vector3(477.29, -1003.58, 26.27)
	local board_scaleform
	local overlay
	local overlay_model = GetHashKey("prop_police_id_text")

	local camera_scaleform
	local cam
	local cam2

	--
	local TakePhoto = N_0xa67c35c56eb1bd9d
	local WasPhotoTaken = N_0x0d6ca79eeebd8ca3
	local SavePhoto = N_0x3dec726c25a11bac
	local ClearPhoto = N_0xd801cc02177fa3f1
	--

	local function Cleanup()
		ReleaseNamedRendertarget("ID_Text")
		SetScaleformMovieAsNoLongerNeeded(board_scaleform)
		DeleteObject(overlay)
		DeleteObject(board)
		DestroyCam(cam, 1)
		DestroyCam(cam2, 1)
		ReleaseNamedScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM")
		ReleaseNamedScriptAudioBank("Mugshot_Character_Creator")
		RemoveAnimDict(lineup_male)
		ClearPedTasksImmediately(PlayerPedId())
		StopPlayerSwitch()
		handle = false
	end

	AddEventHandler('onResourceStop', function (resource)
		if resource == GetCurrentResourceName() then Cleanup() end
	end)

	local function TaskHoldBoard()
		local empty, sequence = OpenSequenceTask(0)
		TaskPlayAnim(0, lineup_male, "react_light", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
		TaskPlayAnim(0, lineup_male, "Loop", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
		CloseSequenceTask(sequence)
		ClearPedTasks(PlayerPedId())
		TaskPerformSequence(PlayerPedId(), sequence)
		ClearSequenceTask(sequence)
	end

	local function TaskRaiseBoard()
		local empty, sequence = OpenSequenceTask(0)
		TaskPlayAnim(0, lineup_male, "low_to_high", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
		TaskPlayAnim(0, lineup_male, "Loop_raised", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
		CloseSequenceTask(sequence)
		ClearPedTasks(PlayerPedId())
		TaskPerformSequence(PlayerPedId(), sequence)
		ClearSequenceTask(sequence)
	end

	local function TaskWalkInToRoom()
		local empty, sequence = OpenSequenceTask(0)
		local ped = PlayerPedId()
		local rot = vector3(0.0, 0.0, 89.80)
		DoScreenFadeOut(1000)
		TaskPlayAnimAdvanced(0, lineup_male, "Intro", board_pos, rot, 8.0, -8.0, -1, 4608, 0, 2, 0)
		TaskPlayAnim(0, lineup_male, "Loop", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
		CloseSequenceTask(sequence)
		ClearPedTasks(ped)
		TaskPerformSequence(ped, sequence)
		ClearSequenceTask(sequence)
	end

	local function ConfigCameraUI(bool)
		CallScaleformMethod(camera_scaleform, 'OPEN_SHUTTER', 250)
		if bool then
			CallScaleformMethod(camera_scaleform, 'SHOW_PHOTO_FRAME', false)
			CallScaleformMethod(camera_scaleform, 'SHOW_PHOTO_BORDER', true, -0.7, 0.5, 0.5, 162, 120)
		else
			CallScaleformMethod(camera_scaleform, 'SHOW_REMAINING_PHOTOS', true)
			CallScaleformMethod(camera_scaleform, 'SET_REMAINING_PHOTOS', 0, 1)
			CallScaleformMethod(camera_scaleform, 'SHOW_PHOTO_FRAME', true)
			CallScaleformMethod(camera_scaleform, 'SHOW_PHOTO_BORDER', false)
		end
	end

	local function TaskTakePicture()
		local ped = PlayerPedId()

		CallScaleformMethod(camera_scaleform, 'CLOSE_SHUTTER', 250)
		if RequestScriptAudioBank("Mugshot_Character_Creator", false, -1) then
			PlaySound(-1, "Take_Picture", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)
		end

		TakePhoto()
		if WasPhotoTaken() --[[and SavePhoto(-1)]] then

		end
		ConfigCameraUI(true)
		ClearPhoto()
	end

	local function ExitRoom ()
		TriggerEvent('instance:leave')
		local empty, sequence = OpenSequenceTask(0)
		TaskPlayAnim(0, lineup_male, "outro", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
		TaskPlayAnim(0, lineup_male, "outro_loop", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
		CloseSequenceTask(sequence)
		ClearPedTasks(PlayerPedId())
		TaskPerformSequence(PlayerPedId(), sequence)
		ClearSequenceTask(sequence)
		TaskLookAtCoord(PlayerPedId(), GetCamCoord(cam), -1, 10240, 2)
		Wait(9500)
		DoScreenFadeOut(1000)
		Wait(2000)
		Cleanup()
		RenderScriptCams(false,  false,  0,  true,  true)
		enable = false
		EnableAllControlActions(0)
		FreezeEntityPosition(GetPlayerPed(-1), false)
		DisplayRadar(true)
		SetEntityVisible(GetPlayerPed(-1), true, 0)
		SetEntityCoords(GetPlayerPed(-1), -1247.176, -728.55, 21.42, 0.0, 0.0, 0.0, true)
    	SetEntityHeading(GetPlayerPed(-1), 130.97)
		Wait(1000)
		ESX.UI.HUD.SetDisplay(1.0)
		DisplayRadar(true)
		SetEntityVisible(GetPlayerPed(-1), true, 0)
		RageUI:CloseAll()
		local playerPed = GetPlayerPed(-1)
		TriggerServerEvent('esx_skin:save', Character)
		TriggerEvent('skinchanger:loadSkin', Character)
		DoScreenFadeIn(2000)
		PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 0)
		HideHudAndRadarThisFrame(true)
		TriggerEvent("ShowBienvenue")
	end

	local function func_1636 (cam, f1, f2, f3, f4)
		N_0xf55e4046f6f831dc(cam, f1)
		N_0xe111a7c0d200cbc5(cam, f2)
		SetCamDofFnumberOfLens(cam, f3)
		SetCamDofMaxNearInFocusDistanceBlendLevel(cam, f4)
	end

	-- Camera
	Citizen.CreateThread(function ()
		-- SCRIPT::SHUTDOWN_LOADING_SCREEN();
		DoScreenFadeOut(0)

		-- Booth cam
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
		SetCamCoord(cam, 474.99, -999.77, 27.00)
		SetCamRot(cam, 0.0, 0.0, 181.03)
		SetCamFov(cam, 70.97171)
		ShakeCam(cam, "HAND_SHAKE", 0.1)

		-- Show booth cam eventually
		Wait(5000)
		ConfigCameraUI(false)
		SetCamActive(cam, true)

		cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
		SetCamCoord(cam2, 474.32, -1001.77, 26.40) -- In room
		SetCamRot(cam2, 0.0, 0.0, 181.03)
		SetCamFov(cam2, 80.97171)

		while DoesCamExist(cam) do
			if not IsCamInterpolating(cam) and not IsCamInterpolating(cam2) then
				RenderScriptCams(true, false, 3000, 1, 0, 0)
			end
			Wait(0)
		end
	end)

	-- Fade in
	Citizen.CreateThread(function ()
		Wait(500)
		if IsScreenFadedOut() or IsScreenFadingOut() then
			DoScreenFadeIn(500)
		end
	end)

	Citizen.CreateThread(function ()
		local ped = PlayerPedId()

		SetEntityCoords(interior_pos)
		SetPlayerVisibleLocally(PlayerId(), false)
		FreezeEntityPosition(ped, true)
		RequestModel(board_model)
		RequestModel(overlay_model)
		RequestAnimDict(lineup_male);
		RequestScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM", false, -1)
		RequestScriptAudioBank("Mugshot_Character_Creator", false, -1)

		while not HasModelLoaded(board_model) or not HasModelLoaded(overlay_model) do Wait(1) end
		while not HasAnimDictLoaded(lineup_male) do Wait(1) end

		board = CreateObject(board_model, board_pos, false, true, false)
		overlay = CreateObject(overlay_model, board_pos, false, true, false)
		AttachEntityToEntity(overlay, board, -1, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		SetModelAsNoLongerNeeded(board_model)
		SetModelAsNoLongerNeeded(overlay_model)

		SetEntityCoords(ped, board_pos)
		ClearPedWetness(ped)
		ClearPedBloodDamage(ped)
		ClearPlayerWantedLevel(PlayerId())
		SetCurrentPedWeapon(ped, GetHashKey("weapon_unarmed"), 1)
		FreezeEntityPosition(ped, false)
		AttachEntityToEntity(board, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)

		-- FIXME
		ClearPedTasksImmediately(ped)
		TaskWalkInToRoom()
		Wait(7000)
		if RequestScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM", false, -1) then
			PlaySoundFrontend(-1, "Lights_On", "GTAO_MUGSHOT_ROOM_SOUNDS", true)
		end

		Wait(500)
		TaskHoldBoard()

		PlaySound(-1, "Zoom_In", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)

		if DoesCamExist(cam2) then
			StopCamShaking(cam2)
			SetCamActiveWithInterp(cam2, cam, 300, 1, 1)
		end

		Wait(5000)
		TaskTakePicture()
		Wait(1000)
		ConfigCameraUI(false)
		SetCamActiveWithInterp(cam, cam2, 300, 1, 1)
		PlaySound(-1, "Zoom_Out", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)
		ExitRoom()
	end)

	-- Draw the id board
	Citizen.CreateThread(function ()
		board_scaleform = LoadScaleform("mugshot_board_01")
		camera_scaleform = LoadScaleform("digital_camera")
		handle = CreateNamedRenderTargetForModel("ID_Text", overlay_model)

		-- headerStr, numStr, footerStr, importedStr, importedCol, rankNum, rankCol
		CallScaleformMethod(board_scaleform, 'SET_BOARD', 'Listory V', "1,500$", 'LOS SANTOS POLICE DEPT', 'Citoyen')
		CallScaleformMethod(camera_scaleform, 'OPEN_SHUTTER', 250)

		while handle do
			HideHudAndRadarThisFrame()
			SetTextRenderId(handle)
			Set_2dLayer(4)
			Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
			DrawScaleformMovie(board_scaleform, 0.405, 0.37, 0.81, 0.74, 255, 255, 255, 255, 0);
			Citizen.InvokeNative(0xC6372ECD45D73BCD, 0)
			SetTextRenderId(GetDefaultScriptRendertargetRenderId())

			Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
			DrawScaleformMovieFullscreen(camera_scaleform, 255, 255, 255, 255, 0);
			Citizen.InvokeNative(0xC6372ECD45D73BCD, 0)
			Wait(0)
		end
	end)
end)