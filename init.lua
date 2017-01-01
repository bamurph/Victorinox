-- This is mostly based off https://github.com/digitalbase/hammerspoon/blob/master/init.lua 
-- Use as reference for the moment

require('methods')
-- require('debug-mode')



-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17", "Enter Hyper")

-- Sequential Keybindings: e.g. Hyper-a, f for finder
a = hs.hotkey.modal.new({}, "F16", "Sequential Hyper")
pressedA = function() a:enter() end
releasedA = function() end
k:bind({}, 'a', "Sequential Hotkey", pressedA, releasedA)
apps = {
  {'s', 'Spotify'}
}
for i, app in ipairs(apps) do
  a:bind({}, app[1], function() launch(app[2]); a:exit(); end)
end



-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
  -- hs.alert.show("Enter Hyper Mode", nil, nil, 10)
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  -- hs.alert.show("Exit Hyper Mode", nil, nil, 10)
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

-- Trigger existing hyper key shortcuts
k:bind({}, 'm', nil, function() hs.eventtap.keyStroke({"cmd","alt","shift","ctrl"}, 'm') end)
k:bind('', 'J', 'Pressed J',function() print'let the record show that J was pressed' end)

-- hs.hotkey.showHotkeys({}, "l")


launch = function(appname)
  hs.application.launchOrFocus(appname)
  k.triggered = true
end

-- Single keybinding for app launch
-- Keybindings here work when hyper key (caps lock) is held down
singleapps = {
  {'s', 'Sublime Text'},
  {'x', 'Xcode'}
}

for i, app in ipairs(singleapps) do
  k:bind({}, app[1], function() launch(app[2]); k:exit(); end)
end

-- App Vars
local browser = hs.window.find("Safari")
local iterm   = hs.window.find("iTerm2")
local code    = hs.window.find("Visual Studio Code")
local finder  = hs.window.find("Finder")
local xcode   = hs.window.find("Xcode")

-- Variable Config
hs.window.animationDuration = 0.0
hs.window.setShadows(false)

local hyper     = {"cmd", "alt", "ctrl", "shift"}
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

-- Window Resize function
-- function aspectResize(frame, percent) 
--   local xResize = frame.w * percent 
--   local yResize = frame.h * percent
--   local xOffset = 0.5 * xResize
--   local yOffset = 0.5 * yResize

--   frame.x = frame.x + xOffset
--   frame.y = frame.y + yOffset
--   frame.w = frame.w + xResize
--   frame.h = frame.h + yResize

--   return frame
-- end

-- function windowAspectResize(window, percent) 
--   local f = window:frame()
--   local nf = aspectResize(f, percent)
--   window:setFrame(nf)
--   return window
-- end

-- Move windows

hs.hotkey.bind(mash, "-", function()
  local win = hs.window.focusedWindow()
  -- windowAspectResize(win, -0.5)
  local f = win:frame()
  f.x = f.x + (0.05 * f.w)
  f.y = f.y + (0.05 * f.h) 
  f.w = f.w * 0.9
  f.h = f.h * 0.9
  win:setFrame(f)
end)

hs.hotkey.bind(mash, "=", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.x = f.x - (0.05 * f.w)
  f.y = f.y - (0.05 * f.h) 
  f.w = f.w / 0.9
  f.h = f.h / 0.9
  win:setFrame(f)
end)

hs.hotkey.bind(mash, "7", function() 
  local win = hs.window.focusedWindow()
  win:centerOnScreen()
end)

-- Window Layouts
local iMac = "iMac"
local layout_code = {
  {"Safari",  nil,         iMac, hs.layout.left30, nil, nil},
  {"Xcode",   nil,         iMac, hs.layout.right70, nil, nil}
}

-- Hotkeys to apply layouts & position windows
hs.hotkey.bind(mash, "x", function() 
  applyLayouts(layout_code) 
end)

hs.hotkey.bind(mash, "1", function ()
  hs.layout.apply(layout_code)
  Xcode:raise()
  Xcode:focus()
end)

-------------------------------------------------------------------------------
-- reload configuration -- Keep this last --
-------------------------------------------------------------------------------
hs.hotkey.bind(mash, "R", function()
  hs.reload()
end)
hs.alert.show("HS Config Loaded", nil, nil, 10)