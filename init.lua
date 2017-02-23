-- This is mostly based off https://github.com/digitalbase/hammerspoon/blob/master/init.lua 
-- Use as reference for the moment
hs.application.enableSpotlightForNameSearches(true)
require('methods')
-- require('debug-mode')
-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17", "K-mode")

-- A global variable for movement mode
w = hs.hotkey.modal.new({}, "F19", "W-Mode")
pressedW = function() w:enter() end
releasedW = function() end
pressedWW = function() w:exit() end

k:bind({}, 'w', "Enter W-Mode", pressedW, releasedW)
w:bind({}, 'w', "Exit W-Mode", pressedWW, releasedW)

-- Sequential Keybindings: e.g. Hyper-a, f for finder
a = hs.hotkey.modal.new({}, "F16", "Sequential Hyper")
pressedA = function() a:enter() end
releasedA = function() end
pressedAA = function() a:exit() end

k:bind({}, 'a', "Enter A-Mode", pressedA, releasedA)
a:bind({}, 'a', "Exit A-Mode", pressedAA, releasedA)

apps = {
  {'s', 'Spotify'},
  {'i', 'iTunes'},
  {'c', 'Messages'}
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

-- Leave Hyper Mode when F18 (Hyper/Capslock) is released,
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

-- Trigger single action hyper key shortcuts
k:bind({}, 'm', nil, function() hs.eventtap.keyStroke({"cmd","alt","shift","ctrl"}, 'm') end)
k:bind('', 'J', 'Pressed J',function() print'let the record show that J was pressed' end)
k:bind({}, 'r', "Reload", function() hs.reload() end)

-- hs.hotkey.showHotkeys({}, "l")

function toggleApplication(app) 
  if app:isHidden() then
    app:unhide() 
    hs.application.launchOrFocus(app:name())
  else 
    app:hide()
  end
end

launch = function(appname)
  local app = hs.application.find(appname)
  if app ~= nil then 
    if app:isRunning() then
      toggleApplication(app)
    end
  else 
    hs.application.launchOrFocus(appname)
  end
  
  k.triggered = true
end

-- Single keybinding for app launch
-- Keybindings here work when hyper key (caps lock) is held down
singleapps = {
  {'s', 'Simulator'},
  {'c', 'Code'},
  {'x', 'Xcode'}
}

for i, app in ipairs(singleapps) do
  k:bind({}, app[1], function() launch(app[2]); end)
end

-- App Vars
local browser = hs.window.find("Safari")
local iterm   = hs.window.find("iTerm2")
local code    = hs.window.find("Visual Studio Code")
local finder  = hs.window.find("Finder")
local xcode   = hs.window.find("Xcode")
local unity   = hs.window.find("Unity")

-- Variable Config
hs.window.animationDuration = 0.0
hs.window.setShadows(false)

local hyper     = {"cmd", "alt", "ctrl", "shift"}
local mash      = {"cmd", "alt", "ctrl"}
local mash_apps = {"cmd", "alt"}
local cmd_ctrl  = {"cmd", "ctrl"}
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

-- Nudge and Resize Windows 
function nudge(xpos, ypos) 
  local win = hs.window:focusedWindow()
  local f = win:frame()
  f.x = f.x + xpos
  f.y = f.y + ypos
  win:setFrame(f)
end

function resize(xsize, ysize) 
  local win = hs.window:focusedWindow()
  local f = win:frame()
  f.w = f.w + xsize
  f.h = f.h + ysize
  win:setFrame(f)
end

hs.hotkey.bind(cmd_ctrl, "h", function() 
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.w = f.w * 0.9
  win:setFrame(f)
end)


nudgeLeft = function() nudge(-100, 0) end
nudgeRight = function() nudge(100,0) end
nudgeUp = function() nudge(0,-100) end
nudgeDown = function() nudge(0,100) end

shrinkX = function() resize(-100, 0) end
growX = function() resize(100, 0) end
shrinkY = function() resize(0, -100) end
growY = function() resize(0, 100) end

hs.hotkey.bind(mash, "h", nudgeLeft, nil, nudgeLeft)
hs.hotkey.bind(mash, "l", nudgeRight, nil, nudgeRight)
hs.hotkey.bind(mash, "j", nudgeUp, nil, nudgeUp) 
hs.hotkey.bind(mash, "k", nudgeDown, nil, nudgeDown)

hs.hotkey.bind(cmd_ctrl, "h", shrinkX, nil, shrinkX)
hs.hotkey.bind(cmd_ctrl, "l", growX, nil, growX)
hs.hotkey.bind(cmd_ctrl, "j", shrinkY, nil, shrinkY)
hs.hotkey.bind(cmd_ctrl, "k", growY, nil, growY)


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
local layout_unity = {
  {"Safari",   nil,        iMac, hs.layout.left30, nil, nil},
  {hs.application'Unity':title(),    nil,        iMac, hs.layout.right70, nil, nil}
}

-- Hotkeys to apply layouts & position windows
hs.hotkey.bind(mash, "x", function() 
  applyLayouts(layout_code) 
end)

hs.hotkey.bind(mash, "u", function ()
  applyLayouts(layout_unity) 
  unity:raise()
  unity:focus()
end)

hs.hotkey.bind(mash, "1", function ()
  hs.layout.apply(layout_code)
  xcode:raise()
  xcode:focus()
end)

hs.hotkey.bind(cmd_ctrl, "1", function () 
  local win = hs.window.focusedWindow()
  local app = win:application()
  local layout = { 
    {app:name(), nil, iMac, hs.layout.left30, nil, nil}
  }
  hs.layout.apply(layout)
end)

-------------------------------------------------------------------------------
-- reload configuration -- Keep this last --
-------------------------------------------------------------------------------
hs.hotkey.bind(mash, "R", function()
  hs.reload()
end)
hs.alert.show("HS Config Loaded", nil, nil, 10)