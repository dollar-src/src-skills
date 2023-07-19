Config = {}

Config.Core = 'qb' -- qb / esx
Config.EnableCommand = true
Config.Command = 'skill'
Config.SkillTitle = 'Skills'

Config.Levels = {
   { min = 0, max = 100 }, -- level 1
   { min = 100, max = 200 }, -- level 2
   { min = 200, max = 400 }, -- level 3
   { min = 400, max = 800 }, -- level 4
   { min = 800, max = 1600 }, -- level 5
   { min = 1600, max = 3200 }, -- level 6
   { min = 3200, max = 6400 }, -- level 7
   { min = 6400, max = 12800 }, -- level 8
   { min = 12800, max = 25600 }, -- level 9
   { min = 25600, max = 51200 } -- level 10
}

Config.Skills = {
  ['Mining'] = {
     ["Current"] = 0,
     ["RemoveAmount"] = 0,
     ["Stat"] = 'Mining',
     ['icon'] = 'fas fa-helmet-safety',
  },
  ['Lumberjack'] = {
     ["Current"] = 0,
     ["RemoveAmount"] = 0,
     ["Stat"] = 'Lumberjack',
     ['icon'] = 'fas fa-tree',
  },
  ['Weed'] = {
     ["Current"] = 0,
     ["RemoveAmount"] = 0,
     ["Stat"] = 'Weed',
     ['icon'] = 'fas fa-cannabis',
  },
  ['Grape'] = {
     ["Current"] = 0,
     ["RemoveAmount"] = 0,
     ["Stat"] = 'Grape',
     ['icon'] = 'fas fa-wine-bottle',
  },


}

Config.AddExp = {
  id = 'addexpnotif',
  title = 'XP SYSTEM',
  description = '+',
  description2 = 'XP to ',
  position = 'top-right',
  style = {
      backgroundColor = 'green',
      color = 'white',
      ['.description'] = {
        color = 'white'
      }
  },
  icon = 'check',
  iconColor = 'white'
}