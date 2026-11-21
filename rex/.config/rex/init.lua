-- Rex keybindings, mirroring the Herdr app:
--   herdr-app/.config/herdr-app/keys.json      (global + terminal keys)
--   herdr-app/.config/herdr-app/mods/prefix/   (ctrl+s prefix, read from
--   herdr/.config/herdr/config.toml [keys])
-- Herdr spaces are Rex sessions; tabs and panes are the same.
-- Apply with `rex config reload` or "Reload Config" in the command palette.

-- ctrl+1..9 picks a session by its place in the sidebar; Rex's
-- session.select only takes an ID.
rex.action{
  name  = "session_goto",
  title = "Go to Session by Number",
  args  = { index = "integer" },
  run   = function(ctx, args)
    local r, err = rex.call("session.list")
    if err ~= nil then error(err, 0) end
    local s = r.sessions and r.sessions[args.index]
    if s then rex.client.queue("session.select", { session_id = s.session_id }) end
  end,
}

-- Global keys (keys.json "global")

rex.bind("cmd+t", "client.tab.new")
rex.bind("cmd+w", "client.tab.close")
rex.bind("ctrl+tab", "client.tab.next")
rex.bind("ctrl+shift+tab", "client.tab.previous")
rex.bind("cmd+shift+]", "client.tab.next")
rex.bind("cmd+shift+[", "client.tab.previous")
rex.bind("f2", "client.tab.rename")
for i = 1, 9 do
  rex.bind("cmd+[Digit" .. i .. "]", "client.tab.goto", { index = i })
end

rex.bind("cmd+n", "session.new")
rex.bind("ctrl+n", "session.new")
rex.bind("shift+f2", "session.rename")
for i = 1, 9 do
  rex.bind("ctrl+[Digit" .. i .. "]", "session_goto", { index = i })
end

rex.bind("cmd+d", "pane.split", { direction = "right" })
rex.bind("cmd+shift+d", "pane.split", { direction = "down" })
rex.bind("cmd+shift+w", "pane.close")
rex.bind("cmd+shift+enter", "pane.zoom")
for _, dir in ipairs{ "left", "right", "up", "down" } do
  rex.bind("cmd+alt+" .. dir, "pane.focus", { direction = dir })
  rex.bind("cmd+alt+shift+" .. dir, "pane.move", { direction = dir })
end

-- Herdr's picker (agents, tabs, spaces) is closest to Go to Anything.
rex.bind("cmd+p", "pane.go_to")
rex.bind("cmd+shift+p", "client.palette.toggle")
rex.bind("cmd+,", "client.settings")
-- Rex has no help screen; the palette lists every action and its key.
rex.bind("cmd+/", "client.palette.toggle")
rex.bind("cmd+shift+/", "client.palette.toggle")
rex.bind("cmd+b", "client.sidebar.toggle")
-- Herdr's layout switch flips between sidebar and top-bar layouts.
rex.bind("cmd+shift+l", "client.tab_style.toggle")

rex.bind("cmd+=", "client.font.increase")
rex.bind("cmd+shift+=", "client.font.increase")
rex.bind("cmd+-", "client.font.decrease")
rex.bind("cmd+[Digit0]", "client.font.reset")

-- Terminal keys (keys.json "terminal")

rex.bind("cmd+f", "client.find.open")
rex.bind("alt+left", "pane.send_key", { key = "alt+b" })
rex.bind("alt+right", "pane.send_key", { key = "alt+f" })
rex.bind("alt+backspace", "pane.send_key", { key = "ctrl+w" })
rex.bind("cmd+left", "pane.send_key", { key = "ctrl+a" })
rex.bind("cmd+right", "pane.send_key", { key = "ctrl+e" })
rex.bind("cmd+backspace", "pane.send_key", { key = "ctrl+u" })

-- ctrl+s prefix (herdr [keys], plus the app-only 1..9 and n/p)

local function prefix(key, action, args)
  rex.bind("ctrl+s>" .. key, action, args)
end

-- prefix twice types it into the terminal
prefix("ctrl+s", "pane.send_key", { key = "ctrl+s" })

prefix("shift+/", "client.palette.toggle")       -- help (?)
prefix(",", "client.settings")
prefix("s", "pane.go_to")                         -- goto
prefix("shift+s", "session.switch")               -- workspace_picker
prefix("b", "client.sidebar.toggle")

prefix("shift+n", "session.new")
prefix("shift+w", "session.rename")
prefix("shift+d", "session.close")
for i = 1, 9 do
  prefix("[Digit" .. i .. "]", "session_goto", { index = i })
end

prefix("c", "client.tab.new")
prefix("shift+t", "client.tab.rename")
prefix("n", "client.tab.next")
prefix("p", "client.tab.previous")
prefix("q", "client.tab.close")

prefix("/", "pane.split", { direction = "right" })
prefix("-", "pane.split", { direction = "down" })
prefix("w", "pane.close")
prefix("z", "pane.zoom")
for key, dir in pairs{ h = "left", j = "down", k = "up", l = "right" } do
  prefix(key, "pane.focus", { direction = dir })
  prefix("shift+" .. key, "pane.resize", { direction = dir })
end
