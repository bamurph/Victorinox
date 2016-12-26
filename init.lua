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
local opt       = {"alt"}
local alt       = opt

ext = {
  frame    = {},
  win      = {},
  app      = {},
  utils    = {},
  cache    = {},
  watchers = {}
}



-- Window Layouts
local iMac = "iMac"
local layout_code = {
  {"Safari",  nil,         iMac, hs.layout.left50, nil, nil},
  {"Xcode",   nil,         iMac, hs.layout.right50, nil, nil}
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

hs.hotkey.bind(opt, "1", function ()
  hs.layout.apply(layout_code)
end)