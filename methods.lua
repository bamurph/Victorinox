
-- METHODS - BECAREFUL :)
--------------------------------------------------------------------------------
function applyLayout(layouts, app)
  if (app) then
    local appName = app:title()

    for i, layout in ipairs(layouts) do
      if (type(layout.name) == "table") then
        for i, layAppName in ipairs(layout.name) do
          if (layAppName == appName) then
            hs.alert.show(appName)
          
            local wins = app:allWindows()
            local counter = 1
            for j, win in ipairs(wins) do
              if (win:isVisible() and layout.func) then
                layout.func(counter, win)
                counter = counter + 1
              end
            end
          end
        end
      elseif (type(layout.name) == "string") then
        if (layout.name == appName) then
          local wins = app:allWindows()
          local counter = 1
          for j, win in ipairs(wins) do
            if (win:isVisible() and layout.func) then
              layout.func(counter, win)
              counter = counter + 1
            end
          end
        end
      end
    end
  end
end

function applyLayouts(layouts)

  for i, layout in ipairs(layouts) do
    if (type(layout.name) == "table") then
      --hs.alert.show("Applying Layout in table")
      for i, appName in ipairs(layout.name) do
        --print("Applying Layout in table i -> " .. i)
        --print("Applying Layout in table appName -> " .. appName)
        -- focus or launch
        ext.app.forceLaunchOrFocus(appName)
        local app = hs.application.find(appName)
        
        if (app) then
          local wins = app:allWindows()
          local counter = 1
          for j, win in ipairs(wins) do
            if (win:isVisible() and layout.func) then
              layout.func(counter, win)
              counter = counter + 1
            end
          end
        end
      end
    elseif (type(layout.name) == "string") then
      --hs.alert.show("Applying Layout in string")
      ext.app.forceLaunchOrFocus(appName)
      local app = hs.appfinder.appFromName(layout.name)
      if (app) then
        local wins = app:allWindows()
        local counter = 1
        for j, win in ipairs(wins) do
          if (win:isVisible() and layout.func) then
            layout.func(counter, win)
            counter = counter + 1
          end
        end
      end
    end
  end
end

function hs.screen.get(screen_name)
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    if screen:name() == screen_name then
      return screen
    end
  end
end

-- Returns the width of the smaller screen size
-- isFullscreen = false removes the toolbar
-- and dock sizes
function hs.screen.minWidth(isFullscreen)
  local min_width = math.maxinteger
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    local screen_frame = screen:frame()
    if (isFullscreen) then
      screen_frame = screen:fullFrame()
    end
    min_width = math.min(min_width, screen_frame.w)
  end
  return min_width
end

-- isFullscreen = false removes the toolbar
-- and dock sizes
-- Returns the height of the smaller screen size
function hs.screen.minHeight(isFullscreen)
  local min_height = math.maxinteger
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    local screen_frame = screen:frame()
    if (isFullscreen) then
      screen_frame = screen:fullFrame()
    end
    min_height = math.min(min_height, screen_frame.h)
  end
  return min_height
end

-- If you are using more than one monitor, returns X
-- considering the reference screen minus smaller screen
-- = (MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2
-- If using only one monitor, returns the X of ref screen
function hs.screen.minX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + ((refScreen:frame().w - hs.screen.minWidth()) / 2)
  end
  return min_x
end

-- If you are using more than one monitor, returns Y
-- considering the focused screen minus smaller screen
-- = (MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2
-- If using only one monitor, returns the Y of focused screen
function hs.screen.minY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + ((refScreen:frame().h - hs.screen.minHeight()) / 2)
  end
  return min_y
end

-- If you are using more than one monitor, returns the
-- half of minX and 0
-- = ((MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2) / 2
-- If using only one monitor, returns the X of ref screen
function hs.screen.almostMinX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + (((refScreen:frame().w - hs.screen.minWidth()) / 2) - ((refScreen:frame().w - hs.screen.minWidth()) / 4))
  end
  return min_x
end

-- If you are using more than one monitor, returns the
-- half of minY and 0
-- = ((MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2) / 2
-- If using only one monitor, returns the Y of ref screen
function hs.screen.almostMinY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + (((refScreen:frame().h - hs.screen.minHeight()) / 2) - ((refScreen:frame().h - hs.screen.minHeight()) / 4))
  end
  return min_y
end

-- Returns the frame of the smaller available screen
-- considering the context of refScreen
-- isFullscreen = false removes the toolbar
-- and dock sizes
function hs.screen.minFrame(refScreen, isFullscreen)
  return {
    x = hs.screen.minX(refScreen),
    y = hs.screen.minY(refScreen),
    w = hs.screen.minWidth(isFullscreen),
    h = hs.screen.minHeight(isFullscreen)
  }
end