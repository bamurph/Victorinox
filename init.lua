-- This is mostly based off https://github.com/digitalbase/hammerspoon/blob/master/init.lua 
-- Use as reference for the moment

require('methods')
-- require('debug-mode')



-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17", "K-mode")

-- Sequential Keybindings: e.g. Hyper-a, f for finder
a = hs.hotkey.modal.new({}, "F16", "Sequential Hyper")

-- Window Management Mode
w = hs.hotkey.modal.new({}, "F19", "Window Management")

pressedA = function() a:enter() end
releasedA = function() end
pressedAA = function() a:exit() end

pressedW = function() w:enter() end
releasedW = function() end
pressedWW = function() w:exit() end

k:bind({}, 'w', "Window Management Mode", pressedW, releasedW)
w:bind({}, 'w', "Exit Window Management Mode", pressedWW, releasedW)

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
browser = hs.application.find("Safari"):mainWindow()
iterm   = hs.application.find("iTerm2"):mainWindow()
code    = hs.application.find("Code"):mainWindow()
finder  = hs.application.find("Finder"):mainWindow()
xcode   = hs.application.find("Xcode"):mainWindow()

-- Variable Config
hs.window.animationDuration = 0.0
hs.window.setShadows(false)

hyper     = f18
mash      = {"cmd", "alt", "ctrl"}
mash_apps = {"cmd", "alt"}
opt       = {"alt"}
alt       = opt

ext = {
  frame    = {},
  win      = {},
  app      = {},
  utils    = {},
  cache    = {},
  watchers = {}
}

--
-- Window Layout & Repositioning 
--


k:bind(hyper, "-", function()
  local win = hs.window.focusedWindow()
  -- windowAspectResize(win, -0.5)
  local f = win:frame()
  f.x = f.x + (0.05 * f.w)
  f.y = f.y + (0.05 * f.h) 
  f.w = f.w * 0.9
  f.h = f.h * 0.9
  win:setFrame(f)
end)

k:bind(hyper, "=", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.x = f.x - (0.05 * f.w)
  f.y = f.y - (0.05 * f.h) 
  f.w = f.w / 0.9
  f.h = f.h / 0.9
  win:setFrame(f)
end)

k:bind({}, "7", function() 
  local win = hs.window.focusedWindow()
  win:centerOnScreen()
end)

-- Window Layouts
local iMac = "iMac"
local layout_Xcode = {
  {"Safari",  nil,         iMac, hs.layout.left30, nil, nil},
  {"Xcode",   nil,         iMac, hs.layout.right70, nil, nil}
}

-- Hotkeys to apply layouts & position windows
k:bind({}, "1", function() 
  hs.layout.apply(layout_Xcode)
  xcode:focus()
  safari:raise()
end)

k:bind({}, "1", function ()
  hs.layout.apply(layout_Xcode)
  local x = xcode:application()
  local xw = x:mainWindow()
  xw:raise()
  xw:focus()
end)

-------------------------------------------------------------------------------
-- reload configuration -- Keep this last --
-------------------------------------------------------------------------------
k:bind({}, "R", function()
  hs.reload()
end)
hs.alert.show("HS Config Loaded", nil, nil, 10)