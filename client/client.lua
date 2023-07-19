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

    for _, v in ipairs(sortedSkills) do
        local SkillLevel = 'Unknown'
        local color = ""

        for i, limit in ipairs(Config.Levels) do
            if v.Current > limit.min and (v.Current <= limit.max or i == #Config.Levels) then
                SkillLevel = 'Level '..(i - 1)..' - XP: '..math.round(v.Current)
                v.Min = limit.min
                v.Max = limit.max
                break
            end
        end

        local cu = math.floor((v.Current - v.Min) / (v.Max - v.Min) * 100)

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
            description = '( '..SkillLevel..' ) Total XP ( '..math.round(v.Max)..' )',
            progress = cu,
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

