---@diagnostic disable: undefined-global, missing-parameter
if Config.Core == "qb" then
    Core = exports["qb-core"]:GetCoreObject()
    SetConvar("ox:primaryColor", "red")
elseif Config.Core == "esx" then
    Core = exports["es_extended"]:getSharedObject()
end



lib.callback.register('skillsystem:fetchStatus', function(source, cb)
    if Config.Core == 'qb' then
	local Player = Core.Functions.GetPlayer(source)
	if Player then
		local status = MySQL.scalar.await('SELECT skills FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid})
		if status ~= nil then
			return json.decode(status)
		else
			return nil
		end
	else
		return 
	end
else
	local Player = Core.GetPlayerFromId(source)
	if Player then
		local status = MySQL.scalar.await('SELECT skills FROM users WHERE identifier = ?', {Player.identifier})
		if status ~= nil then
			return json.decode(status)
		else
			return nil
		end
	else
		return 
	end
end
end)

RegisterServerEvent('skillsystem:update', function (data)
    if Config.Core == 'qb' then
      local Player = Core.Functions.GetPlayer(source)
	 MySQL.query('UPDATE players SET skills = @skills WHERE citizenid = @citizenid', {
		['@skills'] = data,
		['@citizenid'] = Player.PlayerData.citizenid

        
	})
    else
        local Player = Core.GetPlayerFromId(source)
        MySQL.query('UPDATE users SET skills = @skills WHERE identifier = @identifier', {
           ['@skills'] = data,
           ['@identifier'] = Player.identifier
       })

    end
end)


local function CheckVersion()
    PerformHttpRequest(
        "https://raw.githubusercontent.com/dollar-src/src-pawnshop/main/version.txt",
        function(err, newestVersion, headers)
            local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
            if not newestVersion then
                print("probably github down follow update on discord / discord.gg/tebex")
                return
            end
            local advice = "^6You are currently running an outdated version^7, ^0please update"
            if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then
                advice = "^6You are running the latest version."
            else
                if currentVersion > newestVersion then
                    advice = "^6You are running the latest version."

                else
                print("^3Version Check^7: ^2Current^7: " .. currentVersion .. " ^2Latest^7: " .. newestVersion)
                end
            end
            print(advice)
        end
    )
end

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CheckVersion()

 
    end
end)
