local hyper = {"cmd", "ctrl", "alt", "shift"}
local super = {"cmd", "ctrl", "alt"}

--------------------------------------------------------------------------------
-- Reusable functions {{{
--------------------------------------------------------------------------------

function switchApp(key, appName)
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(appName)
  end)
end

--------------------------------------------------------------------------------
-- Taken from https://github.com/rtoshiro/hammerspoon-init/blob/master/init.lua
--------------------------------------------------------------------------------

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

-- +-----------------+
-- |        |        |
-- |        |  HERE  |
-- |        |        |
-- +-----------------+
function hs.window.right(win)
  -- local minFrame = hs.screen.minFrame(win:screen(), false)
  local screen = win:screen()
  local minFrame = screen:frame()
  minFrame.x = minFrame.x + (minFrame.w/2)
  minFrame.w = minFrame.w/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |        |        |
-- |  HERE  |        |
-- |        |        |
-- +-----------------+
function hs.window.left(win)
  -- local minFrame = hs.screen.minFrame(win:screen(), false)
  local screen = win:screen()
  local minFrame = screen:frame()
  minFrame.w = minFrame.w/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function hs.window.up(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function hs.window.down(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.y = minFrame.y + minFrame.h/2
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |  HERE  |        |
-- +--------+        |
-- |                 |
-- +-----------------+
function hs.window.upLeft(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.w = minFrame.w/2
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |                 |
-- +--------+        |
-- |  HERE  |        |
-- +-----------------+
function hs.window.downLeft(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x,
    y = minFrame.y + minFrame.h/2,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +-----------------+
-- |                 |
-- |        +--------|
-- |        |  HERE  |
-- +-----------------+
function hs.window.downRight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x + minFrame.w/2,
    y = minFrame.y + minFrame.h/2,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +-----------------+
-- |        |  HERE  |
-- |        +--------|
-- |                 |
-- +-----------------+
function hs.window.upRight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x + minFrame.w/2,
    y = minFrame.y,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +------------------+
-- |                  |
-- |    +--------+    +--> minY
-- |    |  HERE  |    |
-- |    +--------+    |
-- |                  |
-- +------------------+
-- Where the window's size is equal to
-- the smaller available screen size
function hs.window.fullscreenCenter(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame(minFrame)
end

-- +------------------+
-- |                  |
-- |  +------------+  +--> minY
-- |  |    HERE    |  |
-- |  +------------+  |
-- |                  |
-- +------------------+
function hs.window.fullscreenAlmostCenter(win)
  local offsetW = hs.screen.minX(win:screen()) - hs.screen.almostMinX(win:screen())
  win:setFrame({
    x = hs.screen.almostMinX(win:screen()),
    y = hs.screen.minY(win:screen()),
    w = hs.screen.minWidth(isFullscreen) + (2 * offsetW),
    h = hs.screen.minHeight(isFullscreen)
  })
end

-- It's like fullscreen but with minY and minHeight values
-- +------------------+
-- |                  |
-- +------------------+--> minY
-- |       HERE       |
-- +------------------+--> minHeight
-- |                  |
-- +------------------+
function hs.window.fullscreenWidth(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = win:screen():frame().x,
    y = minFrame.y,
    w = win:screen():frame().w,
    h = minFrame.h
  })
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- It's like fullscreen but with minX and minWidth values
-- +----+--------+----+
-- |    |        |    |
-- |    |        |    |
-- |    |  HERE  |    |
-- |    |        |    |
-- |    |        |    |
-- +----+--------+----+
--      |        |
--      |        +--> minWidth
--      +--> minX
function hs.window.fullscreenHeight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    y = win:screen():frame().y,
    x = minFrame.x,
    h = win:screen():frame().h,
    w = minFrame.w
  })
end

-- +------------------+
-- |                  |
-- |    +--------+    +--> minY
-- |    |  HERE  |    |
-- |    +--------+    |
-- |                  |
-- +------------------+
function hs.window.center(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = win:screen():frame().w/2 - minFrame.w/3,
    y = win:screen():frame().h/2 - minFrame.h/3,
    w = minFrame.w/3*2,
    h = minFrame.h/3*2
  })
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--   1/3
-- +-----+-----------+
-- |     |           |
-- |HERE |           |
-- |     |           |
-- +-----+-----------+
function hs.window.leftThird(win)
  -- local minFrame = hs.screen.minFrame(win:screen(), false)
  local screen = win:screen()
  local minFrame = screen:frame()
  minFrame.w = minFrame.w/3
  minFrame.h = minFrame.h
  win:setFrame(minFrame)
end

--         1/3
-- +-----+-----+-----+
-- |     |     |     |
-- |     |HERE |     |
-- |     |     |     |
-- +-----+-----+-----+
function hs.window.middleThird(win)
  -- local minFrame = hs.screen.minFrame(win:screen(), false)
  local screen = win:screen()
  local minFrame = screen:frame()
  win:setFrame({
    x = minFrame.x + minFrame.w/3,
    y = minFrame.y,
    w = minFrame.w/3,
    h = minFrame.h
  })
end

--               1/3
-- +-----------+-----+
-- |           |     |
-- |           | HERE|
-- |           |     |
-- +-----------+-----+
function hs.window.rightThird(win)
  -- local minFrame = hs.screen.minFrame(win:screen(), false)
  local screen = win:screen()
  local minFrame = screen:frame()
  win:setFrame({
    x = minFrame.x + minFrame.w/3 + minFrame.w/3,
    y = minFrame.y,
    w = minFrame.w/3,
    h = minFrame.h
  })
end

--      2/3
-- +-----------+-----+
-- |           |     |
-- |   HERE    |     |
-- |           |     |
-- +-----------+-----+
function hs.window.twoThirdsLeft(win)
  local screen = win:screen()
  local maxFrame = screen:frame()
  maxFrame.w = maxFrame.w/3*2
  maxFrame.h = maxFrame.h
  win:setFrame(maxFrame)
end

--            2/3
-- +-----+-----------+
-- |     |           |
-- |     |    HERE   |
-- |     |           |
-- +-----+-----------+
function hs.window.twoThirdsRight(win)
  local screen = win:screen()
  local maxFrame = screen:frame()
  win:setFrame({
    x = maxFrame.x + maxFrame.w/3,
    y = maxFrame.y,
    w = maxFrame.w/3*2,
    h = maxFrame.h
  })
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--   1/4
-- +----+------------+
-- |    |            |
-- |HERE|            |
-- |    |            |
-- +----+------------+
function hs.window.leftQuarter(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.w = minFrame.w/4
  minFrame.h = minFrame.h
  win:setFrame(minFrame)
end

--               1/4
-- +------------+----+
-- |            |    |
-- |            |HERE|
-- |            |    |
-- +------------+----+
function hs.window.rightQuarter(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x + minFrame.w/4 + minFrame.w/4 + minFrame.w/4,
    y = minFrame.y,
    w = minFrame.w/4,
    h = minFrame.h
  })
end

--      3/4
-- +------------+----+
-- |            |    |
-- |    HERE    |    |
-- |            |    |
-- +------------+----+
function hs.window.threeQuartersLeft(win)
  local screen = win:screen()
  local maxFrame = screen:frame()
  maxFrame.w = maxFrame.w/3*2
  maxFrame.h = maxFrame.h
  win:setFrame(maxFrame)
end

--           3/4
-- +----+------------+
-- |    |            |
-- |    |   HERE     |
-- |    |            |
-- +----+------------+
function hs.window.threeQuartersRight(win)
  local screen = win:screen()
  local maxFrame = screen:frame()
  win:setFrame({
    x = maxFrame.x + maxFrame.w/3,
    y = maxFrame.y,
    w = maxFrame.w/3*2,
    h = maxFrame.h
  })
end
-- }}}

--------------------------------------------------------------------------------
-- Window sizing {{{
--------------------------------------------------------------------------------

hs.hotkey.bind(super, "Left", function()
  hs.window.focusedWindow():left()
end)

hs.hotkey.bind(super, "Right", function()
  hs.window.focusedWindow():right()
end)

hs.hotkey.bind(super, "Up", function()
  hs.window.focusedWindow():up()
end)

hs.hotkey.bind(super, "Down", function()
  hs.window.focusedWindow():down()
end)

hs.hotkey.bind(super, "Return", function()
  hs.window.focusedWindow():maximize()
end)

hs.hotkey.bind(super, "Z", function()
  hs.window.focusedWindow():upLeft()
end)

hs.hotkey.bind(super, "U", function()
  hs.window.focusedWindow():upRight()
end)

hs.hotkey.bind(super, "N", function()
  hs.window.focusedWindow():downRight()
end)

hs.hotkey.bind(super, "B", function()
  hs.window.focusedWindow():downLeft()
end)

hs.hotkey.bind(super, "H", function()
  hs.window.focusedWindow():center()
end)

hs.hotkey.bind(super, "+", function()
  hs.window.focusedWindow():leftThird() -- Super+1
end)

hs.hotkey.bind(super, "ě", function() -- Super+2
  hs.window.focusedWindow():middleThird()
end)

hs.hotkey.bind(super, "š", function() -- Super+3
  hs.window.focusedWindow():rightThird()
end)

hs.hotkey.bind(super, "č", function() -- Super+4
  hs.window.focusedWindow():twoThirdsLeft()
end)

hs.hotkey.bind(super, "ř", function() -- Super+5
  hs.window.focusedWindow():twoThirdsRight()
end)

hs.hotkey.bind(super, ",", function() -- Super+?
  local win = hs.window.focusedWindow()
  local frame = win:frame()
  local dimensions = "x=" .. frame.x .. ", y=" .. frame.y .. ", w=" .. frame.w .. ", h=" .. frame.h
  local appName = win:application():name()
  hs.notify.show("Window dimensions", appName, dimensions)
end)

hs.hotkey.bind(super, "C", function() -- Super+C
  hs.window.focusedWindow():fullscreenHeight()
end)
-- }}}

--------------------------------------------------------------------------------
-- App switching {{{
--------------------------------------------------------------------------------

switchApp("A", "Adium")
switchApp("B", "RubyMine")
switchApp("C", "Google Chrome")
switchApp("D", "Dash")
switchApp("E", "SourceTree")
switchApp("F", "Path Finder")
switchApp("G", "TogglDesktop")
switchApp("K", "Slack")
switchApp("L", "Sublime Text")
switchApp("I", "Eclipse")
switchApp("M", "TextMate")
switchApp("N", "nvALT")
switchApp("P", "Postman")
switchApp("S", "Safari")
switchApp("T", "iTerm")
switchApp("U", "iTunes")
switchApp("V", "MacVim")
switchApp("X", "Firefox")
switchApp("W", "Neovim")
-- }}}

--------------------------------------------------------------------------------
-- Window movement {{{
--------------------------------------------------------------------------------

hs.hotkey.bind(hyper, "Up", function()
  hs.window.focusedWindow():moveOneScreenNorth()
end)

hs.hotkey.bind(hyper, "Down", function()
  hs.window.focusedWindow():moveOneScreenSouth()
end)

hs.hotkey.bind(hyper, "Left", function()
  hs.window.focusedWindow():moveOneScreenWest()
end)

hs.hotkey.bind(hyper, "Right", function()
  hs.window.focusedWindow():moveOneScreenEast()
end)
-- }}}

--------------------------------------------------------------------------------
-- WiFi-based auto settings {{{
--------------------------------------------------------------------------------

local wifiWatcher = nil
local homeSSID = "Alternative4"
local lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
  newSSID = hs.wifi.currentNetwork()

  if newSSID ~= homeSSID and lastSSID == homeSSID then
    -- Just departed our home WiFi network
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.notify.show("Hammerspoon", "", "Volume set to 0")
  end

  if (newSSID == "DTC-VNET" or newSSID == "UVS" or newSSID == "EBC") and newSSID ~= "DTC-VNET" and newSSID ~= "UVS" and newSSID ~= "EBC" then
    -- Just joined one of work WiFi networks
    hs.notify.show("Hammerspoon", "", "Let's get to work :)")
    hs.application.open("Adium")
    hs.application.open("Slack")
  end

  if newSSID == homeSSID and lastSSID ~= homeSSID then
    -- Just joined our home WiFi network
    -- hs.notify.show("Hammerspoon", "", "Welcome home :)")
    local adium = hs.application.find("Adium")
    if adium:isRunning() then
      hs.applescript('tell application "Adium" to go offline')
    end
  end

  lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
-- }}}

--------------------------------------------------------------------------------
-- Hammerspoon stuff {{{
--------------------------------------------------------------------------------

-- Reload configuration
hs.hotkey.bind(super, "R", function()
  hs.reload()
end)
hs.notify.show("Hammerspoon", "", "Config loaded")
-- }}}
-- vim:foldmethod=marker:foldenable
