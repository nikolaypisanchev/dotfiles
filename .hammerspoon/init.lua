function toggleLaunch(name, app)
    return function()
        local prog = hs.application.find(name)
        if not prog then
            hs.application.launchOrFocus(app)
        end

        if prog:isFrontmost() then
            prog:hide()
        else
            prog:activate()
        end
    end
end

-- hs.hotkey.bind({"alt"}, "space", toggleLaunch("alacritty", "/Applications/Alacritty.app"))
-- hs.hotkey.bind({"alt"}, ",", toggleLaunch("alacritty", "/Applications/Alacritty.app"))
hs.hotkey.bind({"alt"}, "o", toggleLaunch("ollama", "/Applications/Ollama.app/Contents/MacOS/Ollama"))

-- hs.hotkey.bind({"alt"}, "n", function()
--   local a, b = hs.application.find('alacritty')
--   if b:isFrontmost() then
--     b:hide()
--   else
--     b:activate()
--   end
-- end)

-- hs.hotkey.bind({"alt"}, "m", function()
--   local a, b, c = hs.application.find('alacritty')
--   if c:isFrontmost() then
--     c:hide()
--   else
--     c:activate()
--   end
-- end)

hs.hotkey.bind({"alt"}, "c", toggleLaunch("chrome", "/Applications/Google Chrome.app"))
hs.hotkey.bind({"alt"}, "f", toggleLaunch("firefox", "/Applications/Firefox.app"))

function transform(x, what)
  if type(x) == 'string' then

    negate = x:find('-')

    if x:find('full') then
      x = hs.window.frontmostWindow():screen():frame()[what]
    elseif x:find('half') then
      x = hs.window.frontmostWindow():screen():frame()[what] / 2
    end

    if negate then
        x = -x
    end
  end

  return x
end

function tile (x, y, w, h)
  return function()
    local win = hs.window.frontmostWindow()

    win:setTopLeft(transform(x, 'w'), transform(y, 'h'))
    win:setSize(transform(w, 'w'), transform(h, 'h'))
  end
end

hs.hotkey.bind({"alt"}, "a", tile(0, 0, 'half', 'full'))
hs.hotkey.bind({"alt"}, "d", tile('half', 0, 'half', 'full'))
hs.hotkey.bind({"alt"}, "s", tile(0, 0, 'full', 'full'))
hs.hotkey.bind({"alt"}, "w", tile(0, 0, 'full', 'half'))
hs.hotkey.bind({"alt"}, "x", tile(0, 'half', 'full', 'half'))

hs.hotkey.bind({"alt"}, "j", tile('-full', 'half', 'half', 'full'))
-- hs.hotkey.bind({"alt"}, "j", tile(0, 'half', 'half', 'full'))
hs.hotkey.bind({"alt"}, "l", tile('-half', 'half', 'half', 'full'))
hs.hotkey.bind({"alt"}, "k", tile('-full', '-full', 'full', 'full'))

-- alacritty management:
local ALACRITTY = "/Applications/Alacritty.app/Contents/MacOS/alacritty"

local function windowArgs(title)
  return { "--title", title, "-o", "window.dynamic_title=false" }
end

local function findWindow(app, title)
  for _, window in ipairs(app:allWindows()) do
    if window:title() == title then
      return window
    end
  end
  return nil
end

local function focusOrLaunch(title)
  local app = hs.application.get("org.alacritty")

  if app == nil then
    -- Alacritty isn't running: start it once, and its first window gets this title
    local args = { "-a", "Alacritty", "--args" }
    for _, arg in ipairs(windowArgs(title)) do table.insert(args, arg) end
    hs.task.new("/usr/bin/open", nil, args):start()
    return
  end

  local window = findWindow(app, title)
  if window ~= nil then
    if app:isFrontmost() and hs.window.focusedWindow() == window then
      app:hide()
    else
      app:unhide()
      window:unminimize()
      window:focus()
    end
    return
  end

  -- Alacritty is running: ask that same process to open another window
  local args = { "msg", "create-window" }
  for _, arg in ipairs(windowArgs(title)) do table.insert(args, arg) end
  hs.task.new(ALACRITTY, function(exitCode, _, stdErr)
    if exitCode ~= 0 then
      hs.alert.show("alacritty msg failed: " .. stdErr)
    end
  end, args):start()
end

local slots = {
  ["1"] = "one",
  ["2"] = "two",
  ["3"] = "three",
  ["4"] = "four",
  ["5"] = "five",
  m = "main",
  n = "scratch",
  [","] = "logs",
  space = "some",
}

for key, title in pairs(slots) do
  hs.hotkey.bind({ "alt" }, key, function() focusOrLaunch(title) end)
end
