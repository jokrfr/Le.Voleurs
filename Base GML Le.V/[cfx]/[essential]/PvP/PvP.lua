-- CLIENTSIDED --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if pvpEnabled then
            --for i = 0,32 do
            for i = 0,64 do --bentobug
                if NetworkIsPlayerActive(i) then
                    SetCanAttackFriendly(GetPlayerPed(i), true, true)
                    NetworkSetFriendlyFireOption(true)
                end
            end
        end
    end
end)
