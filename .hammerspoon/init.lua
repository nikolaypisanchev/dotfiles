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

hs.hotkey.bind({"alt"}, "space", toggleLaunch("alacritty", "/Applications/Alacritty.app"))

hs.hotkey.bind({"alt"}, "m", function()
  local a, b = hs.application.find('alacritty')
  if b:isFrontmost() then
    b:hide()
  else
    b:activate()
  end
end)

hs.hotkey.bind({"alt"}, "n", function()
  local a, b, c = hs.application.find('alacritty')
  if c:isFrontmost() then
    c:hide()
  else
    c:activate()
  end
end)

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
hs.hotkey.bind({"alt"}, "l", tile('-half', 'half', 'half', 'full'))
hs.hotkey.bind({"alt"}, "k", tile('-full', '-full', 'full', 'full'))

