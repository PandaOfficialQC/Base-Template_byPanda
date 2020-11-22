------- Add appartments and their positions here

appartements = {
	{ 
		ext = {name = "1 Salle - Hall-principal", x = -1096.3503417969, y = -850.11041259766, z = 19.001203536987-1.001, h = 39.06},
		appts = {
			{name = "-1 Salle - Cellules-de-détention/garage", x = -1096.4840087891, y = -850.0830078125, z = 4.8841795921326-1.001, h = 39.06},
			{name = "-2 Salle - Salles-de-preuve/laboratoire", x = -1096.3061523438, y = -850.20513916016, z = 10.276628494263-1.001, h = 39.06},
			{name = "-3 Salle - Garage/Armurerie", x = -1096.3273925781, y = -850.12567138672, z = 13.687370300293-1.001, h = 39.06},
			{name = "2 Salle - Café/Sheriff-Dpt", x = -1096.3275146484, y = -850.13134765625, z = 23.038642883301-1.001, h = 39.06},
			{name = "3 Salle - Vestiaire/Gym/Armurerie/Bureaux", x = -1096.3118896484, y = -850.04034423828, z = 26.827590942383-1.001, h = 39.06},
			{name = "4 Salle - Centre d'opérations/Bureau du lieutenant", x = -1096.2993164063, y = -850.07202148438, z = 30.757154464722-1.001, h = 39.06},
			{name = "5 Salle - Bureau des détectives/Bureau du capitaine", x = -1096.3863525391, y = -849.93432617188, z = 34.360733032227-1.001, h = 39.06},
			{name = "6 Salle - Toit d'héliport", x = -1096.4581298828, y = -849.95629882813, z = 38.243228912354-1.001, h = 39.06}
		}
	}
}



local nameTimer = 0
local nameOnScreen = false
local nameText = ""

function ShowHelp(text)
	Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayHelp(0, false, 1, 0)
end

function DrawSub(text)
	SetTextFont(1)
	SetTextScale(0.7, 0.7)
	SetTextColour(255, 255, 255, 255)
	SetTextWrap(0.2,  0.8)
	SetTextCentre(1)
	SetTextOutline(true)
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.8, 0.9)
end

function Teleport(x, y, z, h)
	local e = GetPlayerPed(-1)
	DoScreenFadeOut(800)
	while not IsScreenFadedOut() do
		Wait(10)
	end
	SetEntityCoordsNoOffset(e, x + 0.0, y + 0.0, z + 1.5, 0, 0, 1)
	SetEntityHeading(e, h + 0.0)
	Wait(500)
	DoScreenFadeIn(800)
	while not IsScreenFadedIn() do
		Wait(10)
	end
end

function ShowName(name)
	nameText = name
	nameTimer = GetGameTimer() + 5000
	nameOnScreen = true
end


AddEventHandler("appt:teleport", function(apid, id)
	Teleport(appartements[apid].appts[id].x, appartements[apid].appts[id].y, appartements[apid].appts[id].z, appartements[apid].appts[id].h)
	ShowName(appartements[apid].appts[id].name)
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1)
		local pedPos = GetEntityCoords(GetPlayerPed(-1), 0)
		for id=1, #appartements do

			-- Immeuble

			local dist_ext = GetDistanceBetweenCoords(appartements[id].ext.x + 0.0, appartements[id].ext.y + 0.0, appartements[id].ext.z + 0.5, pedPos, true)
			if dist_ext < 15 then-- Test de distance pour afficher le marqueur. (Qu'on ne le voit pas de loin)
				if dist_ext <= 0.9 then -- Distance Interne Marqueur pour déclencher la téléportation
					ShowHelp("Appuyez sur ~INPUT_VEH_HORN~ Pour Entrer.")
					if IsControlJustReleased(0, 86) then
						if #appartements[id].appts == 1 then
							Teleport(appartements[id].appts[1].x, appartements[id].appts[1].y, appartements[id].appts[1].z, appartements[id].appts[1].h)
							ShowName(appartements[id].appts[1].name)
						else
							ShowMenu(id, appartements[id].appts)
						end
					end
				end
				-- Affiche le marqueur. (A commenter si pas besoin du marqueur affiché.)
				DrawMarker(1, appartements[id].ext.x + 0.0, appartements[id].ext.y + 0.0, appartements[id].ext.z + 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 0, 160, 255, 60, 0, 0, 2, 0, 0, 0, 0)
			end

			if dist_ext < 1.9 and dist_ext > 1.2 then
				CloseMenu()
			end
			-- Etages d'immeuble

			local appts = appartements[id].appts
			for appt=1, #appts do
				local dist_in = GetDistanceBetweenCoords(appts[appt].x + 0.0, appts[appt].y + 0.0, appts[appt].z + 0.5, pedPos, true)
				if dist_in < 8 then -- Test de distance pour afficher le marqueur. (Qu'on ne le voit pas de loin)
					if dist_in <= 1.3 then -- Distance Interne Marqueur pour déclencher la téléportation
						ShowHelp("Appuyez sur ~INPUT_VEH_HORN~ pour aller à la salle principale")
						if IsControlJustReleased(0, 86) then
							Teleport(appartements[id].ext.x, appartements[id].ext.y, appartements[id].ext.z, appartements[id].ext.h)
							ShowName(appartements[id].ext.name)
						end
					end
					-- Affiche le marqueur. (A commenter si pas besoin du marqueur affiché.)
					DrawMarker(1, appts[appt].x + 0.0, appts[appt].y + 0.0, appts[appt].z + 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.4, 2.4, 0.5, 0, 160, 255, 90, 0, 0, 2, 0, 0, 0, 0)
				end
			end
		end

		if nameOnScreen then
			if GetGameTimer() < nameTimer then
				DrawSub(nameText)
			else
				nameOnScreen = false
			end
		end

	end

end)

