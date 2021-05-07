ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local properties = {}
local propertyOwner = {}
local ownedProperties = {}
local trustedProperties = {}
local playersInProperties = {}
local vanishedUser = {}
local isinProperty = false
local gotAllProperties = false
local isinMarker = false
local isNearMarker = false
local isinRoomMenu = false
local currentLocation = nil
local propertyID = nil
local isinLeaveMarker = false
local ownedByCharname = nil
local currentPropertyData = nil
local onlyVisit = false
local currentEnterLoc = {}
local currentMapBlip

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

	TriggerServerEvent('myProperties:getProperties')
	TriggerServerEvent('myProperties:registerPlayer') -- muss bei playerloaded ausgeführt werden

	ESX.TriggerServerCallback('myProperties:getLastProperty', function(propertyName)
		if propertyName ~= 0 then
			for k, props in pairs(propertyOwner) do
				if tonumber(props.id) == tonumber(propertyName) then
					local name = props.property
					for k2, v in pairs(properties) do
						if v.name == name then
							propertyID = props.id
							TriggerServerEvent('myProperties:enterProperty', tonumber(propertyName), v)
						end
					end
					break
				end
			end
		end
	end)
end)

Citizen.CreateThread(function()

		--TriggerServerEvent('myProperties:getProperties') --DEBUG

		while not gotAllProperties do
			Wait(100)
		end
		for k, prop in pairs(properties) do
			local coords = prop.entering
			if prop.is_buyable then
				if prop.is_unique then
					for k2, owned in pairs(propertyOwner) do
						if owned.property == prop.name then
							prop.showBlip = false
							-- Haus gehört jemandem
							break
						elseif k2 == #propertyOwner then
							prop.showBlip = true
							if ConfigProp.ShowAvailableBlips then
								local blip = AddBlipForCoord(coords.x, coords.y)
								SetBlipSprite(blip, 40)
								SetBlipDisplay(blip, 6)
								SetBlipScale(blip, 0.5)
								SetBlipColour(blip, 4)
								SetBlipAsShortRange(blip, true)
								BeginTextCommandSetBlipName("STRING");
								AddTextComponentString(Translation[ConfigProp.Locale]['blip_available_prop'])
								EndTextCommandSetBlipName(blip)
							end
						end
					end
				else
					prop.showBlip = true
					if ConfigProp.ShowAvailableBlips then
						local blip = AddBlipForCoord(coords.x, coords.y)
						SetBlipSprite(blip, 40)
						SetBlipDisplay(blip, 6)
						SetBlipScale(blip, 0.5)
						SetBlipColour(blip, 4)
						SetBlipAsShortRange(blip, true)
						BeginTextCommandSetBlipName("STRING");
						AddTextComponentString(Translation[ConfigProp.Locale]['blip_available_prop'])
						EndTextCommandSetBlipName(blip)
					end	
				end
			end

			for k2, ownedprop in pairs(ownedProperties) do
				if ownedprop.property == prop.name then
					
					local blip = AddBlipForCoord(coords.x, coords.y)
					SetBlipSprite(blip, 40)
					SetBlipDisplay(blip, 6)
					SetBlipScale(blip, 0.5)
					SetBlipColour(blip, 2)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName("STRING");
					AddTextComponentString(Translation[ConfigProp.Locale]['blip_prop_owned'])
					EndTextCommandSetBlipName(blip)
					--[[--]]
				end
			end

			if #trustedProperties > 0 then
				for k3, trustProp in pairs(trustedProperties) do
					if trustProp.property == prop.name then
						local blip = AddBlipForCoord(coords.x, coords.y)
						SetBlipSprite(blip, 40)
						SetBlipDisplay(blip, 6)
						SetBlipScale(blip, 0.5)
						SetBlipColour(blip, 3)
						SetBlipAsShortRange(blip, true)
						BeginTextCommandSetBlipName("STRING");
						if trustProp.owner ~= nil then
							AddTextComponentString(Translation[ConfigProp.Locale]['blip_keyowner'] .. trustProp.owner)
						else
							AddTextComponentString(Translation[ConfigProp.Locale]['blip_keyowner_unknown'])
						end
						EndTextCommandSetBlipName(blip)
					end
				end
			end



		end

end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		if isinProperty then
		
			if currentPropertyData ~= nil then
			
				DrawMarker(23, currentPropertyData.room_menu.x, currentPropertyData.room_menu.y, currentPropertyData.room_menu.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*1.5, 1.0*1.5, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
				DrawMarker(23, currentPropertyData.inside.x, currentPropertyData.inside.y, currentPropertyData.inside.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*1.0, 1.0*1.0, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
			
			end
		
		end

		if isNearMarker then
			DrawMarker(23, currentEnterLoc.x, currentEnterLoc.y, currentEnterLoc.z - 0.99, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9*0.9, 0.9*0.9, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
		end

		if isinMarker then
			showInfobar("~INPUT_PICKUP~ Information sur le(s) logement(s)")
			if IsControlJustReleased(0, 38) then
				for k, prop in pairs(properties) do
					if currentLocation == prop.id then
						if prop.depends ~= 'Collector' then -- Wenn nur eine Wohnung
							if #ownedProperties > 0 then
								for i=1, #ownedProperties, 1 do
									if ownedProperties[i].property == prop.name then
										propertyID = ownedProperties[i].id
										RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
										
										generateEstateMenu(prop, true)
										break
									else 
										if i == #ownedProperties then
											RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
											generateEstateMenu(prop, false)
											
										end
									end
								end
							else
								RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
								generateEstateMenu(prop, false)
								
							end
						else -- wenn mehrere
							local propsDepend = {}
							for k2, propdep in pairs(properties) do
								if propdep.depends == prop.name then
									table.insert(propsDepend, {
										name = propdep.name,
										label = propdep.label,
									})
								end
								if k2 == #properties then
									RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart'), true)
									generateSelectMenu(prop, propsDepend)
									
								end
							end
						end
						break
					end
				end
				
			end
		elseif isinLeaveMarker then
			
			showInfobar("~INPUT_PICKUP~ Quitter le logement")
			if IsControlJustReleased(0, 38) then
				RageUI.Visible(RMenu:Get('core', 'menuprop_quitprop'), true)
				generateDoorMenu()
			end
		elseif isinRoomMenu then
			
			showInfobar("~INPUT_PICKUP~ Coffre du logement")
			if IsControlJustReleased(0, 38) then
				for i=1, #propertyOwner, 1 do
					if propertyOwner[i].id == propertyID then
						RageUI.Visible(RMenu:Get('core', 'menuprop_coffre'), true)
						generateWardrobeMenu(propertyOwner[i].owner)
						break
					end
				end
			end
		else
			
		end
		

	end

end)

function setNearestBlip(loc)
 if currentMapBlip ~= nil then
	RemoveBlip(currentMapBlip)
 end
 currentMapBlip = AddBlipForCoord(loc.x, loc.y)
 SetBlipSprite(currentMapBlip, 40)
 SetBlipDisplay(currentMapBlip, 6)
 SetBlipScale(currentMapBlip, 0.5)
 SetBlipColour(currentMapBlip, 4)
 SetBlipAsShortRange(blip, true)
 BeginTextCommandSetBlipName("STRING");
 AddTextComponentString(Translation[ConfigProp.Locale]['blip_available_prop'])
 EndTextCommandSetBlipName(currentMapBlip)

end

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(400)

		isinMarker = false
		isNearMarker = false
		isinLeaveMarker = false
		isinRoomMenu = false


		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local closestDistance = 10000

		for k, prop in pairs(properties) do
			--[[if prop.depends ~= 'Collector' then
				local distanceLeave = Vdist(playerCoords, prop.inside.x, prop.inside.y, prop.inside.z)

				if distanceLeave <= 1.5 then
					isinLeaveMarker = true
					currentLocation = prop.id
				end
			end--]]
			
			if prop.is_single then
				local coords = prop.entering
				local distance = Vdist(playerCoords, coords.x, coords.y, coords.z)
				
				if ConfigProp.ShowOnlyNearestProperty then
					if distance < closestDistance and prop.showBlip then
						closestDistance = distance
						setNearestBlip(coords)
					end
				end

				if distance <= 1.5 then
					isNearMarker = true
					isinMarker = true
					currentEnterLoc = coords
					currentLocation = prop.id
				elseif distance <= 25.0 then
					isNearMarker = true
					currentEnterLoc = coords
				end

			end
		end

		if isinProperty then
			if currentPropertyData ~= nil then
				local distanceLeave = Vdist(playerCoords, currentPropertyData.inside.x, currentPropertyData.inside.y, currentPropertyData.inside.z)
				if distanceLeave <= 1.5 then
					isinLeaveMarker = true
				end
				local distanceRoommenu = Vdist(playerCoords, currentPropertyData.room_menu.x, currentPropertyData.room_menu.y, currentPropertyData.room_menu.z)
				if distanceRoommenu <= 1.5 then
					isinRoomMenu = true
				end
			end

		end


	end


end)

Citizen.CreateThread(function()

	RMenu.Add('core', 'menuprop_achat', RageUI.CreateMenu("Immobilier", "none")) 
	RMenu:Get('core', 'menuprop_achat'):SetRectangleBanner(39, 41, 39, 100)
	RMenu.Add('core', 'menuprop_listepropentrer', RageUI.CreateMenu("Immobilier", "none")) 
	RMenu:Get('core', 'menuprop_listepropentrer'):SetRectangleBanner(39, 41, 39, 100)
	RMenu.Add('core', 'menuprop_listeappart', RageUI.CreateMenu("Immobilier", "none")) 
	RMenu:Get('core', 'menuprop_listeappart'):SetRectangleBanner(39, 41, 39, 100)
	RMenu.Add('core', 'menuprop_quitprop', RageUI.CreateMenu("Immobilier", "none")) 
	RMenu:Get('core', 'menuprop_quitprop'):SetRectangleBanner(39, 41, 39, 100)
	RMenu.Add('core', 'menuprop_coffre', RageUI.CreateMenu("Immobilier", "none")) 
	RMenu:Get('core', 'menuprop_coffre'):SetRectangleBanner(39, 41, 39, 100)

end)

local prorpriete = {main = false, listekey = false, appart = false, menuquit = false, menupropiete}
local clesystem = {action = {"Ouverture à tout le monde", "Ouverture à clé de logement"}, index = 1}


function generateWardrobeMenu(owner)
	if prorpriete.menupropiete then
		return
	end
	prorpriete.menupropiete = true
	while prorpriete.menupropiete do
		Wait(1)
		if not RageUI.Visible(RMenu:Get('core', 'menuprop_coffre')) then
			prorpriete.menupropiete = false
		end
		collectgarbage()
		RageUI.Visible(RMenu:Get('core', 'menuprop_coffre'), true)
		RageUI.IsVisible(RMenu:Get('core', 'menuprop_coffre'), true, true, true, function()
			local isOwner = false
			local trustedPlayersList = {}
			local currentDeposit = 0
			for k, ownedProp in pairs(ownedProperties) do
				if ownedProp.id == propertyID then
					isOwner = true
					break
				end
			end
			if isOwner then
				RageUI.Checkbox("Attribuer un double de(s) clé du logement", nil, ListeCle, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
					if Selected and Checked ~= ListeCle then
						ListeCle = Checked
					end
				end)
				if ListeCle then 
					RageUI.Separator("« ~«~Individus ayant un double~s~ »")
					for k, props in pairs(propertyOwner) do
						if propertyID == props.id then
							trustedPlayersList = props.trusted
							for i=1, #props.trusted, 1 do
								RageUI.Button(props.trusted[i].name, nil, {RightLabel = '~r~Retirer'}, true, function(Hovered, Active, Selected)
									if Selected then
										TriggerServerEvent('myProperties:updateTrusted', "del", trustedPlayersList[i].steamID, propertyID)
									end
								end)		
							end
						end
					end
					RageUI.Separator("« ~b~Individus en ville~s~ »")
					local playersInArea = ESX.Game.GetPlayersInArea(currentPropertyData.room_menu, 3.0)
					for k, player in pairs(playersInArea) do
						RageUI.Button(GetPlayerName(player), nil, {}, true, function(Hovered, Active, Selected)
							if Selected then
								TriggerServerEvent('myProperties:updateTrusted', "add", GetPlayerServerId(playersInArea[k]), propertyID)
							end
						end)
					end
				end
			end
			if not onlyVisit then
				for k, props in pairs(propertyOwner) do
					if propertyID == props.id then
						currentDeposit = props.deposit
					end
		
				end
				RageUI.CenterButton("« Argent stocker ~g~" .. currentDeposit .. "$~s~ »", nil, {}, true, function(Hovered, Active, Selected)
				end)
				RageUI.Button("Déposer de l'argent", nil, {}, true, function(Hovered, Active, Selected)
					if Selected then 
						local res_amount = CreateDialog("Somme à déposer")
						if tonumber(res_amount) then
							local quantity = tonumber(res_amount)
							TriggerServerEvent('myProperties:editPropDeposit', 'deposit', quantity, propertyID)
						end
					end
				end)

				RageUI.Button("Retirer de l'argent", nil, {}, true, function(Hovered, Active, Selected)
					if Selected then
						local res_amount = CreateDialog("Somme à retirer")
						if tonumber(res_amount) then
							local quantity = tonumber(res_amount)
							TriggerServerEvent('myProperties:editPropDeposit', 'withdraw', quantity, propertyID)
						end
					end
				end)
			end
		end)
	end
end

function generateDoorMenu()
	if prorpriete.menuquit then
		return
	end
	prorpriete.menuquit = true
	while prorpriete.menuquit do
		Wait(1)
		if not RageUI.Visible(RMenu:Get('core', 'menuprop_quitprop')) then
			prorpriete.menuquit = false
		end
		RageUI.Visible(RMenu:Get('core', 'menuprop_quitprop'), true)
		RageUI.IsVisible(RMenu:Get('core', 'menuprop_quitprop'), true, true, true, function()
			collectgarbage()

			RageUI.Checkbox("Faire rentrer un individus", nil, ListeInvite, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
				if Selected and Checked ~= ListeInvite then
					ListeInvite = Checked
				end
			end)

			if ListeInvite then 
				local playersInArea = ESX.Game.GetPlayersInArea(currentPropertyData.entering, 10.0)
				for k, player in pairs(playersInArea) do
					RageUI.Button("Faire rentrer : ~b~" .. GetPlayerName(player) .. "~s~", nil, {}, true, function(Hovered, Active, Selected)
						if Selected then 
							TriggerServerEvent('myProperties:invitePlayer', GetPlayerServerId(playersInArea[k]), propertyID, currentPropertyData)
							ESX.ShowNotification("Vous avez inviter ~b~" .. GetPlayerName(playersInArea[k]))
						end
					end)
		     	end
			end
			local changePropPlate
			if not onlyVisit then
				RageUI.List("Rescriction (~o~Ouverture~s~)", clesystem.action, clesystem.index, nil, {}, true, function(Hovered, Active, Selected, Index) 
					if Selected then
						if Index == 1 then
							ESX.ShowNotification("- Rescriction d'ouverture\n- Ouverture à ~b~tout le monde~s~.")
							TriggerServerEvent('myProperties:saveLockState', propertyID, 2)
						elseif Index == 2 then
							ESX.ShowNotification("- Rescriction d'ouverture\n- Ouverture à ~g~clé~s~.")
							TriggerServerEvent('myProperties:saveLockState', propertyID, 1)
						end
					end
					clesystem.index = Index
				end) 
				RageUI.Button("Changer le label du logement", nil, {RightLabel = '~g~' .. ConfigProp.ChangeDoorbellPrice .. "$"}, true, function(Hovered, Active, Selected)
					if Selected then
						local res_plate = CreateDialog(Translation[ConfigProp.Locale]['doorbell'])
						if res_plate ~= nil and res_plate ~= '' then
							TriggerServerEvent('myProperties:editPropPlate', propertyID, res_plate)
							RageUI.Visible(RMenu:Get('core', 'menuprop_quitprop'), false)
						end
					end
				end)
			end
			RageUI.Button("Sortir du logement", nil, {}, true, function(Hovered, Active, Selected)
				if Selected then
					RageUI.Visible(RMenu:Get('core', 'menuprop_quitprop'), false)
					TriggerServerEvent('myProperties:leaveProperty', currentPropertyData)
				end
			end)
		end)
	end
end

function generateSelectMenu(base, PropsBelongtoBase)
	if prorpriete.appart then
		return
	end
	prorpriete.appart = true
	while prorpriete.appart do
		Wait(1)
		if not RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart')) then
			prorpriete.appart = false
		end
		RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart'), true)
		RageUI.IsVisible(RMenu:Get('core', 'menuprop_listeappart'), true, true, true, function()
			collectgarbage()

			local selectedProp = {}
			RageUI.Separator("« Bâtiment : ~y~".. base.label .. "~s~ »")
			RageUI.Separator("« Nombres de logement : [~b~" .. #PropsBelongtoBase .. "~s~] »")

			for k, prop in pairs(PropsBelongtoBase) do
				local found = false
				local propID = prop.id
				for k2, ownedProps in pairs(ownedProperties) do
					if ownedProps.property == prop.name then
						RageUI.Button("Logement Acquis : ~g~".. prop.label, nil, {RightLabel = prop.type}, true, function(Hovered, Active, Selected)
							if Selected then
								for k2, prope in pairs(properties) do
									if prope.name  == PropsBelongtoBase[k].name then
										selectedProp = prope
										break
									end
								end
								if #ownedProperties > 0 then
									for i=1, #ownedProperties, 1 do
										if ownedProperties[i].property == selectedProp.name then
											propertyID = ownedProperties[i].id
											generateEstateMenu(selectedProp, true)
											RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
											RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart'), false)
											break
										else 
											if i == #ownedProperties then
												RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
												RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart'), false)
												generateEstateMenu(selectedProp, false)
												
											end
										end
									end
								else
									RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
									RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart'), false)
									generateEstateMenu(selectedProp, false)
									
								end
							end
						end)
						found = true
						break
					end
				end
				if not found then
					RageUI.Button(prop.label, nil, {}, true, function(Hovered, Active, Selected)
						if Selected then
							for k2, prope in pairs(properties) do
								if prope.name  == PropsBelongtoBase[k].name then
									selectedProp = prope
									break
								end
							end
							if #ownedProperties > 0 then
								for i=1, #ownedProperties, 1 do
									if ownedProperties[i].property == selectedProp.name then
										propertyID = ownedProperties[i].id
										generateEstateMenu(selectedProp, true)
										RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
										RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart'), false)
										break
									else 
										if i == #ownedProperties then
											RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
											generateEstateMenu(selectedProp, false)
											RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart'), false)
											
										end
									end
								end
							else
								RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
								RageUI.Visible(RMenu:Get('core', 'menuprop_listeappart'), false)
								generateEstateMenu(selectedProp, false)
								
							end
						end
					end)
				end
			end
		end)
	end
end
function generateEstateMenu(prop, owns)
	if prorpriete.main then
		return
	end
	prorpriete.main = true
	while prorpriete.main do
		Wait(1)
		if not RageUI.Visible(RMenu:Get('core', 'menuprop_achat')) then
			prorpriete.main = false
		end
		RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), true)
		RageUI.IsVisible(RMenu:Get('core', 'menuprop_achat'), true, true, true, function()
			collectgarbage()
			local coords = prop.entering
			local s1 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
			local street1 = GetStreetNameFromHashKey(s1)
			RageUI.Button("Type de logement", nil, {RightLabel = prop.type}, true, function(Hovered, Active, Selected)
			end)
			RageUI.Button("Label du logement", nil, {RightLabel = prop.label}, true, function(Hovered, Active, Selected)
			end)
			RageUI.Button("Adresse", nil, {RightLabel = street1}, true, function(Hovered, Active, Selected)
			end)
			if prop.is_unique then
				RageUI.Button("Plusieurs Immobilier", nil, {RightLabel = "~g~Oui"}, true, function(Hovered, Active, Selected)
				end)
			else
				RageUI.Button("Plusieurs Immobilier", nil, {RightLabel = "~r~Non"}, true, function(Hovered, Active, Selected)
				end)
			end
			if owns then
				RageUI.Button("Votre propriété", nil, {RightLabel = "~g~Oui"}, true, function(Hovered, Active, Selected)
				end)
			else
				RageUI.Button("Votre propriété", nil, {RightLabel = "~r~Non"}, true, function(Hovered, Active, Selected)
				end)
			end
			if owns then
				RageUI.Button("Entrer dans la propriété", nil, {RightLabel = ">"}, true, function(Hovered, Active, Selected)
					if Selected then
						RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), false)
						TriggerServerEvent('myProperties:enterProperty', propertyID, prop)
					end
				end)
			end
			RageUI.Button("Autres propriété de disponibles (~b~Acquises~s~)", nil, {}, true, function(Hovered, Active, Selected)
				if Selected then
					RageUI.Visible(RMenu:Get('core', 'menuprop_listepropentrer'), true)
					MenuListeCle(prop)
				end
			end)
			local propertyIsSold = false
			if prop.is_unique then
				for k, ownedProps in pairs(propertyOwner) do
					if ownedProps.property == prop.name then
						RageUI.Button("Nom du propriétaire", nil, {RightLabel = ownedProps.charname}, true, function(Hovered, Active, Selected)
						end)
						propertyIsSold = true
						break
					end	
				end
			end
			if not owns then
				if prop.is_buyable then
					if not propertyIsSold then

						RageUI.Button("Acheter pour le prix de : ~g~" .. prop.price .. "$", nil, {}, true, function(Hovered, Active, Selected)
							if Selected then
								RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), false)
								TriggerServerEvent('myProperties:buy', prop.name, "BUY", prop.price)
							end
						end)

						RageUI.Button("Louer pour le prix de : ~g~" .. prop.price / ConfigProp.CalculateRentPrice .. "$ / Par jour", nil, {}, true, function(Hovered, Active, Selected)
							if Selected then
								RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), false)
								TriggerServerEvent('myProperties:buy', prop.name, "RENT", prop.price / ConfigProp.CalculateRentPrice)
							end
						end)
					end
				end
			else
				local price = 0
				local rented = false
				for k, propOwner in pairs(propertyOwner) do
					if propOwner.id == propertyID then
						price = propOwner.price
						rented = propOwner.rented
						break
					end
				end
				if rented == 1 then	
					RageUI.Button("Arrêter l'acheminement de délais par jour", nil, {}, true, function(Hovered, Active, Selected)
						if Selected then
							RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), false)
							TriggerServerEvent('myProperties:RemoveOwnedProperty', prop.name, 'SOURCE')
							ESX.ShowNotification("Vous avez ~r~arrêter~s~ l'acheminement du logement.")
						end
					end)
				else
					RageUI.Button("Vendre l'immobilier pour : ~g~" .. price / ConfigProp.CalculateSellPrice .. "$", nil, {}, true, function(Hovered, Active, Selected)
						if Selected then
							RageUI.Visible(RMenu:Get('core', 'menuprop_achat'), false)
							ESX.ShowNotification("Vous avez vendus le logement pour : ~g~" .. price / ConfigProp.CalculateSellPrice .. "$")
							TriggerServerEvent('myProperties:RemoveOwnedProperty', prop.name, 'SOURCE')
					        TriggerServerEvent('myProperties:pay', price / ConfigProp.CalculateSellPrice)

						end
					end)
				end
			end	
		end)
	end
end

function MenuListeCle(prop, owns)
	if prorpriete.listekey then
		return
	end
	prorpriete.listekey = true
	while prorpriete.listekey do
		Wait(1)
		if not RageUI.Visible(RMenu:Get('core', 'menuprop_listepropentrer')) then
			prorpriete.listekey = false
		end
		RageUI.Visible(RMenu:Get('core', 'menuprop_listepropentrer'), true)
		RageUI.IsVisible(RMenu:Get('core', 'menuprop_listepropentrer'), true, true, true, function()
			collectgarbage()
			local coords = prop.entering
			local propertiesToSelect = {}
			for k2, trusted in pairs(trustedProperties) do
				if trusted.property == prop.name then
					RageUI.Button("Propriété de ~b~" .. trusted.owner, nil, {RightLabel = "~g~Avec clé"}, true, function(Hovered, Active, Selected, index)
						if Selected then
							table.insert(propertiesToSelect, {id = trusted.id, type = 'key',})
							TriggerServerEvent('myProperties:enterProperty', trusted.id, prop)
							propertyID = trusted.id
							RageUI.Visible(RMenu:Get('core', 'menuprop_listepropentrer'), false)
						end
					end)
				end
			end
			for k3, public in pairs(propertyOwner) do
				if public.property == prop.name then
					if public.locked == 2 then
						RageUI.Button("Propriété publique de ~b~" .. public.charname, nil, {RightLabel = "~g~Ouvert"}, true, function(Hovered, Active, Selected, index)
							if Selected then
								table.insert(propertiesToSelect, {id = public.id, type = 'public',})
								TriggerServerEvent('myProperties:enterProperty', public.id, prop)
								propertyID =  public.id

								if public.type == 'public' then
									onlyVisit = true
								end
								RageUI.Visible(RMenu:Get('core', 'menuprop_listepropentrer'), false)
							end
						end)
					end
				end
			end
		end)
	end
end

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if isinProperty then
			for k, user in pairs(vanishedUser) do
				if user ~= playerPed then
					--SetEntityLocallyInvisible(user)
					--SetEntityNoCollisionEntity(playerPed,  user,  true)
					SetEntityLocallyInvisible(user)
                    SetEntityVisible(user, false, 0)
                    SetEntityNoCollisionEntity(playerPed, user, true)
				end
			end
		end
	end
end)

RegisterNetEvent('myProperties:setPlayerInvisible')
AddEventHandler('myProperties:setPlayerInvisible', function(playerEnter, instanceId)

	
	local otherPlayer = GetPlayerFromServerId(playerEnter)
	
	if otherPlayer ~= nil then
		local otherPlayerPed = GetPlayerPed(otherPlayer)
		table.insert(vanishedUser, otherPlayerPed)
	end

end)

RegisterNetEvent('myProperties:setPlayerVisible')
AddEventHandler('myProperties:setPlayerVisible', function(playerEnter)


	local otherPlayer = GetPlayerFromServerId(playerEnter)
	local otherPlayerPed = GetPlayerPed(otherPlayer)
	
	for k, vanish in pairs(vanishedUser) do
		if vanish == otherPlayerPed then
			table.remove(vanishedUser, k)
		end
	end

end)

RegisterNetEvent('myProperties:enterProperty')
AddEventHandler('myProperties:enterProperty', function(prop)
	
	local playerPed = PlayerPedId()
	local coords = prop.inside
	if prop.ipls ~= '[]' then
		RemoveIpl("apa_v_mp_h_01_b")
		RequestIpl(prop.ipls)
		while not IsIplActive(prop.ipls) do
			Citizen.Wait(0)
		end
	end

	SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
	NetworkSetVoiceChannel(propertyID)
    NetworkSetTalkerProximity(0.0)
	isinProperty = true
	currentPropertyData = prop
	TriggerServerEvent('myProperties:saveLastProperty', propertyID)

end)

RegisterNetEvent('myProperties:leaveProperty')
AddEventHandler('myProperties:leaveProperty', function(prop)

    Citizen.InvokeNative(0xE036A705F989E049)
    NetworkSetTalkerProximity(2.5)
	isinProperty = false	
	onlyVisit = false
	vanishedUser = {}
	local playerPed = PlayerPedId()
	local coords = prop.entering
	SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
	RemoveIpl(prop.ipls)
	TriggerServerEvent('myProperties:saveLastProperty', 0)

end)

RegisterNetEvent('myProperties:sendPropertiesToClient')
AddEventHandler('myProperties:sendPropertiesToClient', function(properties_res, owner_res, steamID)

	properties = properties_res
	propertyOwner = owner_res
	ownedProperties = {}
	trustedProperties = {}

	for k, v in pairs(propertyOwner) do
		if steamID == v.owner then
			table.insert(ownedProperties, {
				id = v.id,
				property = v.property,
			})
		end
		for i=1, #v.trusted, 1 do
			if v.trusted[i].steamID ~= nil then
				if v.trusted[i].steamID == steamID then
					table.insert(trustedProperties, {
						id = v.id,
						property = v.property,
						owner = v.charname,
					})
				end
			end

		end
	end

	gotAllProperties = true


end)

RegisterNetEvent('myProperties:updatePropertyOwner')
AddEventHandler('myProperties:updatePropertyOwner', function(line, updatedTable, steamID)

	propertyOwner[line] = updatedTable

	ownedProperties = {}
	trustedProperties = {}

	for k, v in pairs(propertyOwner) do
		if steamID == v.owner then
			table.insert(ownedProperties, {
				id = v.id,
				property = v.property,
			})
		end
		for i=1, #v.trusted, 1 do
			if v.trusted[i].steamID ~= nil then
				if v.trusted[i].steamID == steamID then
					table.insert(trustedProperties, {
						id = v.id,
						property = v.property,
						owner = v.charname,
					})
				end
			end

		end
	end

end)

-- This event is there to avoid performing the event above on each change of the lock for everyone.
RegisterNetEvent('myProperties:updateLockState')
AddEventHandler('myProperties:updateLockState', function(line, newLockState)

	propertyOwner[line].locked = newLockState

end)

RegisterNetEvent('myProperties:hasInvitation')
AddEventHandler('myProperties:hasInvitation', function(ID, propertyData)

	hasInvite = true

	Citizen.CreateThread(function()
	
		while hasInvite do
			Citizen.Wait(0)
			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('myProperties:enterProperty', ID, propertyData)
				propertyID = ID
				hasInvite = false
				onlyVisit = true
			end

		end
	
	end)

	Citizen.Wait(10000)
	if hasInvite then
		hasInvite = false
		ShowNotification(Translation[ConfigProp.Locale]['invitation_expired'])
	end

end)

--[[RegisterNetEvent('myProperties:receiveCharName')
AddEventHandler('myProperties:receiveCharName', function(charname)
	
	ownedByCharname = charname
	print(ownedByCharname)
end)--]]

--[[RegisterNetEvent('myProperties:updatePlayersInProperties')
AddEventHandler('myProperties:updatePlayersInProperties', function(playersInProps)

	playersInProperties = playersInProps
end)--]]

function showInfobar(msg)

	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showPictureNotification(icon, msg, title, subtitle)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg);
    SetNotificationMessage(icon, icon, true, 1, title, subtitle);
    DrawNotification(false, true);
end

RegisterNetEvent('myProperties:msg')
AddEventHandler('myProperties:msg', function(msg)
	ShowNotification(msg)
end)

RegisterNetEvent('myProperties:picturemsg')
AddEventHandler('myProperties:picturemsg', function(icon, msg, title, subtitle)
	showPictureNotification(icon, msg, title, subtitle)
end)

RegisterNetEvent('myProperties:picturemsg')
AddEventHandler('myProperties:picturemsg', function(icon, msg, title, subtitle)
	showPictureNotification(icon, msg, title, subtitle)
end)

function CreateDialog(OnScreenDisplayTitle_shopmenu) --general OnScreenDisplay for KeyboardInput
	AddTextEntry(OnScreenDisplayTitle_shopmenu, OnScreenDisplayTitle_shopmenu)
	DisplayOnscreenKeyboard(1, OnScreenDisplayTitle_shopmenu, "", "", "", "", "", 32)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local displayResult = GetOnscreenKeyboardResult()
		return displayResult
	end
end


RegisterNetEvent('myProperties:stillOnline')
AddEventHandler('myProperties:stillOnline', function()
	TriggerServerEvent('myProperties:registerPlayer')
end)


Citizen.CreateThread(function()
  RequestIpl('apa_v_mp_h_01_b')
end)


--[[RegisterCommand("Immo", function()
	GetProp()
	RageUI.Visible(RMenu:Get('agentimmobilier', 'menuaction'), not RageUI.Visible(RMenu:Get('agentimmobilier', 'menuaction')))
end)

RMenu.Add('agentimmobilier', 'menuaction', RageUI.CreateMenu("OUI immo", "none"))
RMenu:Get('agentimmobilier', 'menuaction'):SetRectangleBanner(39, 41, 39, 100)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		RageUI.IsVisible(RMenu:Get('agentimmobilier', 'menuaction'), true, true, true, function()
			for k,v in pairs(getprop) do
				RageUI.CenterButton(v.label .. " - ~g~" .. v.price .. "$", nil, {}, true, function(Hovered, Active, Selected)
					if Selected then
					end
				end)
			end
		end) 	
    end
end)

function GetProp()
    getprop = {}
    ESX.TriggerServerCallback("Le.V:GetProperties", function(propriete) 
		for k,v in pairs(propriete) do
            table.insert(getprop,  {label = v.label, price = v.price}) 
        end
    end)
end]]