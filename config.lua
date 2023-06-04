Config = {}

Config.Core = 'qb' -- qb / esx
Config.EnableCommand = true
Config.Command = 'skill'
Config.SkillTitle = 'Skills'

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