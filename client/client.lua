---@diagnostic disable: undefined-global, param-type-mismatch, missing-parameter


RegisterNetEvent('esx:playerLoaded', function()
    Citizen.CreateThread(function()
        FetchSkills()
        while true do
            local seconds = 300 * 1000
            Citizen.Wait(seconds)
            for skill, value in pairs(Config.Skills) do
                UpdateSkill(skill, value["RemoveAmount"])
            end
            TriggerServerEvent("skillsystem:update", json.encode(Config.Skills))
        end
    end)



end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	Citizen.CreateThread(function()
		FetchSkills()
		while true do
			local seconds = 300 * 1000
			Citizen.Wait(seconds)
			for skill, value in pairs(Config.Skills) do
				UpdateSkill(skill, value["RemoveAmount"])
			end
			TriggerServerEvent("skillsystem:update", json.encode(Config.Skills))
		end
	end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        for skill, value in pairs(Config.Skills) do
            Config.Skills[skill]["Current"] = 0
        end
    end)


end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
	  Wait(100)
	  FetchSkills()
   end
end)

AddEventHandler('playerDropped', function (reason)
    for skill, value in pairs(Config.Skills) do
            Config.Skills[skill]["Current"] = 0
        end
end)
FetchSkills = function()
    lib.callback('skillsystem:fetchStatus', source, function(data)
		if data then
            for status, value in pairs(data) do
                if Config.Skills[status] then
                    Config.Skills[status]["Current"] = value["Current"]
                else
                    print("Removing: " .. status) 
                end
            end
	end
        RefreshSkills()
    end)
end

GetCurrentSkill = function(skill)
    return Config.Skills[skill]
end


UpdateSkill = function(skill, amount)
    if not Config.Skills[skill] then
        print("Skill " .. skill .. " does not exist")
        return
    end
    local SkillAmount = Config.Skills[skill]["Current"]
    if SkillAmount + tonumber(amount) < 0 then
        Config.Skills[skill]["Current"] = 0
    elseif SkillAmount + tonumber(amount) > 250000 then
        Config.Skills[skill]["Current"] = 250000
    else
        Config.Skills[skill]["Current"] = SkillAmount + tonumber(amount)
    end
    RefreshSkills()
---@diagnostic disable-next-line: param-type-mismatch
    lib.notify({
        id = 'addexpnotif',
        title = Config.AddExp.title,
        description = Config.AddExp.description .. amount ..Config.AddExp.description2.. skill,
        position = Config.AddExp.position,
        style = {
            backgroundColor = Config.AddExp.style.backgroundColor,
            color = Config.AddExp.style.color,
            ['.description'] = {
                color = 'white'
              }
        },
        icon = Config.AddExp.icon,
        iconColor = Config.AddExp.iconColor
    })
    
	TriggerServerEvent("skillsystem:update", json.encode(Config.Skills))
end

function round(num) 
    return math.floor(num+.5) 
end

function round1(num) 
    return math.floor(num+1) 
end

RefreshSkills = function()
    for type, value in pairs(Config.Skills) do
        if value["Stat"] then
            StatSetInt(value["Stat"], round(value["Current"]), true)
        end
    end
end

exports('CheckSkill', function(skill, val, hasskill)
    if Config.Skills[skill] then
        if Config.Skills[skill]["Current"] >= tonumber(val) then
            hasskill(true)
        else
            hasskill(false)
        end
    else
        print("Skill " .. skill .. " doesn't exist")
        hasskill(false)
    end
end)


local function createSkillMenuOX()
    local options = {}
    local sortedSkills = {}
    for k, v in pairs(Config.Skills) do
        v.name = k 
        table.insert(sortedSkills, v)
    end
    table.sort(sortedSkills, function(a, b)
        return a.Current < b.Current
    end)

    local options = {}
    for _, v in ipairs(sortedSkills) do
        local SkillLevel
        if v['Current'] <= 100 then
            SkillLevel = 'Level 0 - XP: '..math.round(v['Current'])
            v['Min'] = 0
            v['Max'] = 100
        elseif v['Current'] > 100 and v['Current'] <= 200 then
            SkillLevel = 'Level 1 - XP: '..math.round(v['Current'])
            v['Min'] = 100
            v['Max'] = 200
        elseif v['Current'] > 200 and v['Current'] <= 400 then
            SkillLevel = 'Level 2 - XP: '..math.round(v['Current'])
            v['Min'] = 200
            v['Max'] = 400
        elseif v['Current'] > 400 and v['Current'] <= 800 then
            SkillLevel = 'Level 3 - XP: '..math.round(v['Current'])
            v['Min'] = 400
            v['Max'] = 800
        elseif v['Current'] > 800 and v['Current'] <= 1600 then
            SkillLevel = 'Level 4 - XP: '..math.round(v['Current'])
            v['Min'] = 800
            v['Max'] = 1600
        elseif v['Current'] > 1600 and v['Current'] <= 3200 then
            SkillLevel = 'Level 5 - XP: '..math.round(v['Current'])
            v['Min'] = 1600
            v['Max'] = 3200
        elseif v['Current'] > 3200 and v['Current'] <= 6400 then
            SkillLevel = 'Level 6 - XP: '..math.round(v['Current'])
            v['Min'] = 3200
            v['Max'] = 6400
        elseif v['Current'] > 6400 and v['Current'] <= 12800 then
            SkillLevel = 'Level 7 - XP: '..math.round(v['Current'])
            v['Min'] = 6400
            v['Max'] = 12800
        elseif v['Current'] > 12800 then
            SkillLevel = 'Level 8 - XP: '..math.round(v['Current'])
            v['Min'] = 12800
            v['Max'] = 1000000
        else 
            SkillLevel = 'Unknown'
        end
        local cu = math.floor((v['Current'] - v['Min']) / (v['Max'] - v['Min']) * 100)

        local color = ""
        
        if cu >= 0 and cu <= 20 then
            color = "red"
        elseif cu > 20 and cu <= 40 then
            color = "orange"
        elseif cu > 40 and cu <= 70 then
            color = "yellow"
        elseif cu > 70 and cu <= 100 then
            color = "green"
        end
                table.insert(options, {
            arrow = true,
            icon = v.icon,
            title = v.name,
            description = '( '..SkillLevel..' ) Total XP ( '..math.round(v['Max'])..' )',
            progress = math.floor((v['Current'] - v['Min']) / (v['Max'] - v['Min']) * 100),
            colorScheme = color
        })
        
    end
    lib.registerContext({
        id = 'test',
        title = Config.SkillTitle,
        options = options,
    })


    lib.showContext('test')

end
Citizen.CreateThread(function()
    if Config.EnableCommand then
        RegisterCommand(Config.Command, function()
            createSkillMenuOX()

        end)
    end
end)

        
RegisterNetEvent("mz-skills:client:CheckSkills", function()
    createSkillMenuOX()
end)

