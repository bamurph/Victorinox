
-- Sequential Mode Apps (Hyper-A then key)
apps = {
  {'s', 'Spotify'}
}
for i, app in ipairs(apps) do
  a:bind({}, app[1], function() launch(app[2]); a:exit(); end)
end


-- Hyper Mode 

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