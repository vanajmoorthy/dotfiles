-- tmux-style bindings, matching ~/.tmux.conf (prefix ctrl+a).
-- tmux session = Rex session, tmux window = Rex tab, tmux pane = Rex pane.

local function prefix(key, action, args)
  rex.bind("ctrl+a>" .. key, action, args)
end

-- ctrl+a twice sends a literal ctrl+a (shell start-of-line)
prefix("ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- Sessions: s picks one (choose-tree), ( and ) cycle, $ renames
prefix("s", "session.switch")
prefix("shift+9", "session.previous")
prefix("shift+0", "session.next")
prefix("shift+4", "session.rename")

-- Tabs (tmux windows): c new, n/p next/previous, , rename, & close
prefix("c", "client.tab.new")
prefix("n", "client.tab.next")
prefix("p", "client.tab.previous")
prefix(",", "client.tab.rename")
prefix("shift+7", "client.tab.close")
-- tmux numbers windows from 0, Rex numbers tabs from 1
for i = 0, 9 do
  prefix(tostring(i), "client.tab.goto", { index = i + 1 })
end

-- Panes: % splits side by side, " splits top and bottom (British layout: " is shift+2)
prefix("shift+5", "pane.split", { direction = "right" })
prefix("shift+2", "pane.split", { direction = "down" })
prefix("shift+'", "pane.split", { direction = "down" }) -- " on a US layout
prefix("z", "pane.zoom")
prefix("x", "pane.close")
prefix("o", "pane.focus_next")
prefix("shift+1", "pane.move_to_new_tab")

-- Move between panes with hjkl and the arrow keys
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  prefix(key, "pane.focus", { direction = direction })
end

-- Like tmux's repeat-time: after C-a <arrow>, bare arrows keep moving between panes until
-- REPEAT_SECONDS pass without one. Any later arrow goes to the terminal as usual.
local REPEAT_SECONDS = 1.2
local last_move_at = nil

-- os.time() only counts whole seconds. Only called while a move is recent, so ordinary
-- arrow presses never pay for it.
local function now()
  local result = rex.exec({ "/usr/bin/perl", "-MTime::HiRes=time", "-e", "printf q(%.3f), time" })
  return (result and result.ok and tonumber(result.stdout)) or os.time()
end

-- Key-bound functions can't queue client actions, so this goes through the server
local function focus_pane(ctx, direction)
  local _, err = rex.call("session.focus_direction", {
    session_id = ctx.session_id,
    direction = direction,
  })
  if err ~= nil then rex.log(err) end
end

for _, direction in ipairs({ "left", "down", "up", "right" }) do
  prefix(direction, function(ctx)
    last_move_at = now()
    focus_pane(ctx, direction)
    return true
  end)
  rex.bind(direction, function(ctx)
    if last_move_at == nil then
      return false
    end
    local time = now()
    if time - last_move_at > REPEAT_SECONDS then
      last_move_at = nil
      return false
    end
    last_move_at = time
    focus_pane(ctx, direction)
    return true
  end)
end

-- Resize with ctrl+arrows, as tmux's default C-arrow
for _, direction in ipairs({ "left", "down", "up", "right" }) do
  prefix("ctrl+" .. direction, "pane.resize", { direction = direction })
end

-- cmd+1..9 go to the nth session (in `rex ls` order), not the nth tab
rex.action{
  name = "goto_session",
  title = "Go to Session by Number",
  args = { index = "integer" },
  run = function(_, args)
    local result, err = rex.call("session.list")
    if err ~= nil then error(err, 0) end
    local session = result.sessions[args.index]
    if session == nil then return end
    rex.client.queue("session.select", { session_id = session.session_id })
  end,
}
for i = 1, 9 do
  rex.bind("cmd+" .. i, "goto_session", { index = i })
end

-- Tabs (tmux windows) cycle with ctrl+tab, as well as C-a n/p
rex.bind("ctrl+tab", "client.tab.next")
rex.bind("ctrl+shift+tab", "client.tab.previous")

-- C-a C-s / C-a C-r save and restore sessions with ~/.local/bin/rx, like tmux-resurrect did
local RX = os.getenv("HOME") .. "/.local/bin/rx"
-- Rex has no toast, so report through macOS notifications
local function notify(message)
  rex.exec({ "osascript", "-e", "on run argv", "-e",
    "display notification (item 1 of argv) with title \"Rex\"", "-e", "end run", message })
end
for key, command in pairs({ ["ctrl+s"] = "save", ["ctrl+r"] = "restore" }) do
  rex.action{
    name = "rx_" .. command,
    title = "Sessions: " .. command,
    run = function()
      local result, err = rex.exec({ RX, command }, { timeout = 60 })
      local message = err or (result.ok and result.stdout) or result.stderr
      notify(message)
      if err ~= nil or not result.ok then error(message, 0) end
      return { output = result.stdout }
    end,
  }
  prefix(key, "rx_" .. command)
end
