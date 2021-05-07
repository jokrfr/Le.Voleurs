

ESX = nil 


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

local LeVSpawn    = true
local PlayerLoaded  = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerLoaded = true
end)

local playerPed = PlayerPedId()

Animation = {
    {isAnim = true, dic = "anim@amb@nightclub@peds@", name = "rcmme_amanda1_stand_loop_cop"},
    {isAnim = false, h = 359.1, dic = "WORLD_HUMAN_LEANING"},
    {isAnim = false, dic = "WORLD_HUMAN_SMOKING_POT"},
    {isAnim = false, dic = "WORLD_HUMAN_PARTYING"},
    {isAnim = false, dic = "WORLD_HUMAN_MUSCLE_FLEX"},
    {isAnim = true,  dic = "anim@amb@casino@hangout@ped_male@stand@02b@idles", name = "idle_a"}
}

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not PlayerLoaded do
			Citizen.Wait(10)
		end
		if LeVSpawn then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
				else
					TriggerEvent('skinchanger:loadSkin', skin)
					LeVSpawnFunction()
				end
			end)
			LeVSpawn = false
		end
	end)
end)

Id = {}

RegisterNetEvent('Le.V:RegarderLoad')
AddEventHandler('Le.V:RegarderLoad', function(pNom, pPrenom, datedenaissance, sexe, origine, carteid, vie)
	ActiveLoad = true
	Id.nom = tostring(pNom)
	Id.prenom = tostring(pPrenom)
	Id.datedenaissance = tostring(datedenaissance)
	Id.sexe = tostring(sexe)
	Id.origine = tostring(origine)
	Id.carteid = tostring(carteid)
    Id.vie = tostring(vie)
    if Id.nom == '' then
        Id.nom = "~r~Aucun"
    end
    if Id.prenom == '' then
        Id.prenom = "~r~Aucun"
    end
    if Id.datedenaissance == '' then
        Id.datedenaissance = "~r~Aucune"
    end
    if Id.sexe == '' then
        Id.sexe = "~r~Non - précisé(e)"
    end
    if Id.origine == '' then
        Id.origine = "~r~Aucun"
    end
    if Id.carteid == '' then
        Id.carteid = "~r~Aucun"
    end
    print(Id.vie)
end)


local Touche = {"F1", "F6", "F5", "F10", "A", "L", "P", "U", "B", "SPACE", "LEFTSHIFT", "X", "C", "LSHIFT"}


function LeVSpawnFunction()
    TriggerServerEvent(events.ApercuLoad)
    TriggerEvent('Le.V:HudNotView')
    PlayUrl("PlayIntro", "https://www.youtube.com/watch?v=3plS6u_tyTw", 0.5, false)
    FreezeEntityPosition(PlayerPedId(), true)
    SetPlayerInvincible(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), -797.29, 337.400, 189.713, 0.0, 0.0, 0.0, true)
    SetEntityHeading(PlayerPedId(), 29.38)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, -798.80, 339.998, 190.900 )
	SetCamRot(cam, 5.0, 0.0, 210.160)
    SetCamFov(cam, 30.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    DisplayRadar(false)
    loadAnimDict("anim@amb@nightclub@peds@")
    TaskPlayAnim(PlayerPedId(), "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", 2.0, 2.0, -1, 33, 0, false, false, false)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            DrawNiceText(.5, .1, 1.0, "Appuyez sur ~g~ENTER~w~ pour valider votre entrée.", 4, 0)
            DrawNiceText(.5, .05, 1.0, id, 4, 0)
            if ActiveLoad == true then
                for i = 1, #Touche, 1 do
                    DisableControlAction(0, Keys[Touche[i]], true) 
                end
                DrawRect(0.125000000000001, 0.40, 0.185, 0.400, 0, 0, 0, 155)
                DrawAdvancedText2(0.215000000000001, 0.230, 0.000, 0.0028, 0.7, "PERSONNAGE", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText2(0.125000000000001, 0.290, 0.033, 0.0028, 0.4, "Prénom :~b~ ".. Id.prenom, 255, 255, 255, 255, 6, 1)
                DrawAdvancedText2(0.125000000000001, 0.320, 0.033, 0.0028, 0.4, "Nom :~b~ ".. Id.nom, 255, 255, 255, 255, 6, 1)
                DrawAdvancedText2(0.125000000000001, 0.350, 0.033, 0.0028, 0.4, "DDN :~b~ ".. Id.datedenaissance, 255, 255, 255, 255, 6, 1)
                DrawAdvancedText2(0.125000000000001, 0.380, 0.033, 0.0028, 0.4, "Sexe :~b~ ".. Id.sexe, 255, 255, 255, 255, 6, 1)
                DrawAdvancedText2(0.125000000000001, 0.410, 0.033, 0.0028, 0.4, "Origine : ~b~".. Id.origine, 255, 255, 255, 255, 6, 1)
                DrawAdvancedText2(0.125000000000001, 0.440, 0.033, 0.0028, 0.4, "ID : ~y~".. Id.carteid, 255, 255, 255, 255, 6, 1)
                DrawAdvancedText2(0.125000000000001, 0.470, 0.033, 0.0028, 0.4, "Métier : ~b~" .. ESX.PlayerData.job.label .. "~s~ - ~b~" .. ESX.PlayerData.job.grade_label, 255, 255, 255, 255, 6, 1)
                for i = 1, #ESX.PlayerData.accounts, 1 do
                    if ESX.PlayerData.accounts[i].name == 'money' then
                    DrawAdvancedText2(0.125000000000001, 0.500, 0.033, 0.0028, 0.4, "Argent liquide : ~g~" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$", 255, 255, 255, 255, 6, 1)
                    end
                    if ESX.PlayerData.accounts[i].name == "black_money" then
                        DrawAdvancedText2(0.125000000000001, 0.530, 0.033, 0.0028, 0.4, "Argent non déclarée : ~r~" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$", 255, 255, 255, 255, 6, 1)
                    end
                end
                DrawAdvancedText2(0.125000000000001, 0.560, 0.033, 0.0028, 0.4, "Vie : ~g~" .. Id.vie  .. "%", 255, 255, 255, 255, 6, 1)
            end
            if IsControlJustPressed(1, 18) then
                    ActiveLoad = false
                    DoScreenFadeOut(1000)
                    Citizen.Wait(1000)
                    DestroyCam(Camera)
                    Destroy("PlayIntro")
                    ClearFocus()
                    ClearPedTasks(PlayerPedId())
                    DisplayRadar(true)
                    ESX.TriggerServerCallback('Le.V:GetEntityPosition', function()end)
                    RenderScriptCams(0, 0, 3000, 1, 1, 0)
                    FreezeEntityPosition(PlayerPedId(), false)
                    SetPlayerInvincible(PlayerPedId(), false)
                    Wait(2000)
                    DoScreenFadeIn(2000)
                    Wait(1000)
                    TriggerEvent('Le.V:HudView')
                return
            end
        end
    end)
end


RegisterNetEvent('Le.V:GetEntityPosition')
AddEventHandler('Le.V:GetEntityPosition', function(position, vie)
    if position then
        pos = position
    end
    -- StatSetInt("MP0_WALLET_BALANCE", accounts.money, true)
    SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, true)
    Wait(500)
    if tonumber(vie) >= 100 then
        SetEntityHealth(GetPlayerPed(-1), tonumber(vie))
    else
        TriggerEvent('Le.V:HudNotView')
        DisplayRadar(false)
        SetEntityHealth(GetPlayerPed(-1), tonumber(vie))
        ESX.ShowNotification("- Report ~r~Staff~s~\n- ~y~ALT~s~ - ~y~F4~s~ ou ~g~Quit~s~.")
        TriggerServerEvent(events.GiveReport, "~y~ALT~s~ - ~y~F4~s~")
    end
    print(vie)
end)

   --[[ if login then
        return
    end
    login = true;
	PlayUrl("PlayIntro", "https://www.youtube.com/watch?v=3plS6u_tyTw", 0.5, false)
    FreezeEntityPosition(PlayerPedId(), true)
    SetPlayerInvincible(PlayerPedId(), true)
    DestroyAllCams()
    local Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    SetOverrideWeather("EXTRASUNNY")
    NetworkOverrideClockTime(19, 0, 0)
    DoScreenFadeOut(0)
    DoScreenFadeIn(1000)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            DrawNiceText(.5, .1, 1.0, "Appuyez sur ~g~ENTER~w~ pour valider votre entrée.", 4, 0)
            if IsControlJustPressed(1, 18) then
                DoScreenFadeOut(500)
                Citizen.Wait(500)
                DestroyCam(Camera)
				Destroy("PlayIntro")
				ClearFocus()
                RenderScriptCams(0, 0, 3000, 1, 1, 0)
				FreezeEntityPosition(PlayerPedId(), false)
                SetPlayerInvincible(PlayerPedId(), false)
                DoScreenFadeIn(500)
                return
            end
        end
    end)
    SetCamActive(Camera, 1)
    SetCamParams(Camera, 754.2219, 1226.831, 356.5081, -14.367, 0.0, 157.3524, 42.2442, 0, 1, 1, 2)
    SetCamParams(Camera, 740.7797, 1193.923, 351.1997, -9.6114, 0.0, 157.8659, 44.8314, 6500, 0, 0, 2)
    ShakeCam(Camera, "HAND_SHAKE", 0.15)
    RenderScriptCams(true, false, 3000, 1, 1, 0)
    Citizen.Wait(6000)
    SetCamParams(Camera, -259.3686, -553.8571, 142.6048, 13.2752, -0.5186, -143.3378, 44.9959, 0, 1, 1, 2)
    SetCamParams(Camera, -277.7789, -569.962, 142.8625, 12.4479, -0.5186, -134.9992, 44.9959, 6000, 0, 0, 2)
    RenderScriptCams(true, false, 3000, 1, 1, 0)
    Citizen.Wait(5000)
    SetCamParams(Camera, -4.6668, -900.9736, 184.887, -1.6106, -0.5186, 78.3786, 45.0069, 0, 1, 1, 2)
    SetCamParams(Camera, -23.0087, -896.4288, 184.1939, -2.8529, -0.5186, 81.8262, 45.0069, 8000, 0, 0, 2)
    ShakeCam(Camera, "HAND_SHAKE", 0.3)
    RenderScriptCams(true, false, 3000, 1, 1, 0)]]

function DrawNiceText(FsYIVlkf, HLXS0Q_, Kw, nvaIsNv7, vDnoL55, xlAK, zr1y)
    SetTextFont(vDnoL55)
    SetTextScale(Kw, Kw)
    SetTextColour(255, 255, 255, 255)
    SetTextJustification(xlAK or 1)
    SetTextEntry("STRING")
    if zr1y then
        SetTextWrap(FsYIVlkf, FsYIVlkf + .1)
    end
    AddTextComponentString(nvaIsNv7)
    DrawText(FsYIVlkf, HLXS0Q_)
end