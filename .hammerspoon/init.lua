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

function tile (x, y, w, h)
  return function()
      local win = hs.window.frontmostWindow()
      win:setTopLeft(x, y)
      win:setSize(w, h)
    end
end

function ww()
    return hs.window.frontmostWindow():screen():frame().w
end

function wh()
    return hs.window.frontmostWindow():screen():frame().h
end

hs.hotkey.bind({"alt"}, "a", tile(0, 0, ww()/2, wh()))
hs.hotkey.bind({"alt"}, "d", tile(ww()/2, 0, ww()/2, wh()))
hs.hotkey.bind({"alt"}, "s", tile(0, 0, ww(), wh()))
hs.hotkey.bind({"alt"}, "w", tile(0, 0, ww(), wh()/2))
hs.hotkey.bind({"alt"}, "x", tile(0, wh()/2, ww(), wh()/2))

hs.hotkey.bind({"alt"}, "l", tile(-ww(), wh()/2, ww() / 2, wh()))

