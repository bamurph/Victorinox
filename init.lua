-- This is mostly based off https://github.com/digitalbase/hammerspoon/blob/master/init.lua 
-- Use as reference for the moment

require('methods')




-- App Vars
local browser = hs.appfinder.appFromName("Safari")
local iterm   = hs.appfinder.appFromName("iTerm2")
local code    = hs.appfinder.appFromName("Visual Studio Code")
local finder  = hs.appfinder.appFromName("Finder")
local xcode   = hs.appfinder.appFromName("Xcode")

-- Variable Config
hs.window.animationDuration = 0
hs.window.setShadows(false)

local mash      = {"cmd", "alt", "ctrl"}
local mash_apps = {"cmd", "alt"}

ext = {
  frame    = {},
  win      = {},
  app      = {},
  utils    = {},
  cache    = {},
  watchers = {}
}



-- Window Layouts
local layout_code = {
  {
    name = {"Safari"},
    func = function(index, win)
        pushWindow(win,(1/3*2),0,(1/3),1)
    end
  },
  {
    name = {'Xcode'},
    func = function(index, win)
       pushWindow(win,0,0,(1/3*2),1)
    end
  }
}

-- Hotkeys to apply layouts & position windows
hs.hotkey.bind(mash, "x", function() applyLayouts(layout_code) end)


-------------------------------------------------------------------------------
-- reload configuration
-------------------------------------------------------------------------------
hs.hotkey.bind(mash, "R", function()
  hs.reload()
  print('config reloaded')
end)