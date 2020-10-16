hs.hotkey.bind({"alt"}, "space", function()
  local alacritty = hs.application.find('alacritty')
  if alacritty:isFrontmost() then
    alacritty:hide()
  else
    hs.application.launchOrFocus("/Applications/Alacritty.app")
  end
end)

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

hs.hotkey.bind({"alt"}, "c", function()
  local chrome = hs.application.find('chrome')
  if chrome:isFrontmost() then
    chrome:hide()
  else
    hs.application.launchOrFocus("/Applications/Google Chrome.app")
  end
end)

hs.hotkey.bind({"alt"}, "f", function()
  local chrome = hs.application.find('firefox')
  if chrome:isFrontmost() then
    chrome:hide()
  else
    hs.application.launchOrFocus("/Applications/Firefox.app")
  end
end)

hs.hotkey.bind({"alt"}, "a", function()
  local win = hs.window.frontmostWindow()
  local f = win:screen():frame()
  win:setTopLeft(0, 0)
  win:setSize(f.w / 2, f.h)
end)

hs.hotkey.bind({"alt"}, "d", function()
  local win = hs.window.frontmostWindow()
  local f = win:screen():frame()
  win:setTopLeft(f.w / 2, 0)
  win:setSize(f.w / 2, f.h)
end)

hs.hotkey.bind({"alt"}, "w", function()
  local win = hs.window.frontmostWindow()
  local f = win:screen():frame()
  win:setTopLeft(0, 0)
  win:setSize(f.w, f.h)
end)

hs.hotkey.bind({"alt"}, "x", function()
  local win = hs.window.frontmostWindow()
  win:minimize()
end)
