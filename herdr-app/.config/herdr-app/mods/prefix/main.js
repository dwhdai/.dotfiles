// tmux-style prefix for the Herdr app, driven by the herdr TUI's own
// ~/.config/herdr/config.toml [keys], so both share one keymap.
// keys.json binds the prefix itself: "ctrl-s": "mod.open:prefix".
// Opens as a popup that takes the keyboard; the next key runs its
// prefix+<key> action, the prefix again types it into the terminal,
// anything else (Esc included) cancels.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { run, props, closeOverlay, theme, focused, hc, exec, home, readTextFile, notify } from "herdr";

// herdr --default-config [keys], prefix-mode actions only
const DEFAULTS = {
  prefix: "ctrl+b",
  help: "prefix+?",
  settings: "prefix+s",
  workspace_picker: "prefix+w",
  goto: "prefix+g",
  new_workspace: "prefix+shift+n",
  rename_workspace: "prefix+shift+w",
  close_workspace: "prefix+shift+d",
  new_tab: "prefix+c",
  rename_tab: "prefix+shift+t",
  previous_tab: "prefix+p",
  next_tab: "prefix+n",
  switch_tab: "prefix+1..9",
  close_tab: "prefix+shift+x",
  focus_pane_left: "prefix+h",
  focus_pane_down: "prefix+j",
  focus_pane_up: "prefix+k",
  focus_pane_right: "prefix+l",
  split_vertical: "prefix+v",
  split_horizontal: "prefix+minus",
  close_pane: "prefix+x",
  zoom: "prefix+z",
  toggle_sidebar: "prefix+b",
};

// TUI action -> app command. ponytail: TUI-only actions (detach, resize_mode,
// edit_scrollback, worktrees, ...) and [[keys.command]] are skipped; the
// latter mostly shell out to the TUI's own `herdr` CLI.
const ACTIONS = {
  help: ["app.help"],
  settings: ["app.settings"],
  workspace_picker: ["mod.open", { name: "picker" }],
  goto: ["mod.open", { name: "picker" }],
  new_workspace: ["space.new"],
  rename_workspace: ["space.rename"],
  close_workspace: ["space.close"],
  previous_workspace: ["space.prev"],
  next_workspace: ["space.next"],
  previous_agent: ["agent.prev"],
  next_agent: ["agent.next"],
  new_tab: ["tab.new"],
  rename_tab: ["tab.rename"],
  previous_tab: ["tab.prev"],
  next_tab: ["tab.next"],
  close_tab: ["tab.close"],
  focus_pane_left: ["pane.go", { direction: "left" }],
  focus_pane_down: ["pane.go", { direction: "down" }],
  focus_pane_up: ["pane.go", { direction: "up" }],
  focus_pane_right: ["pane.go", { direction: "right" }],
  split_vertical: ["pane.split", { direction: "right" }],
  split_horizontal: ["pane.split", { direction: "down" }],
  close_pane: ["pane.close"],
  zoom: ["pane.zoom"],
  fullscreen: ["pane.zoom"],
  toggle_sidebar: ["layout.toggle", { id: "sidebar" }],
  // no app command for these; handled by resize() below
  resize_pane_left: ["resize", "left"],
  resize_pane_down: ["resize", "down"],
  resize_pane_up: ["resize", "up"],
  resize_pane_right: ["resize", "right"],
};
const INDEXED = { switch_tab: "tab.select", switch_workspace: "space.select" };

// App-only prefix keys, not in the TUI's config; these win over its bindings.
const APP_KEYS = { 9: ["space.prev"], 0: ["space.next"] };

const NAMES = { minus: "-", comma: ",", plus: "+", backtick: "`", ampersand: "&", esc: "escape", period: "." };

// "shift+minus" -> "shift--"; the TUI joins with +, keystrokes with -
const norm = (k) =>
  k.toLowerCase().split("+").map((p) => NAMES[p] ?? p).join("-");

// Only the top-level [keys] table's `name = "value"` lines matter here.
function parseKeys(toml) {
  const keys = {};
  let inKeys = false;
  for (const raw of (toml ?? "").split("\n")) {
    const line = raw.replace(/\s+#.*$/, "").trim();
    if (line.startsWith("[")) { inKeys = line === "[keys]"; continue; }
    const m = inKeys && line.match(/^(\w+)\s*=\s*"([^"]*)"$/);
    if (m) keys[m[1]] = m[2];
  }
  return keys;
}

// keystroke -> [command, args], from prefix+<key> bindings
function buildTable(keys) {
  const table = {};
  for (const [action, binding] of Object.entries(keys)) {
    if (!binding.startsWith("prefix+")) continue;
    const key = binding.slice("prefix+".length);
    if (INDEXED[action] && key.endsWith("1..9")) {
      const mods = key.slice(0, -"1..9".length);
      for (let i = 1; i <= 9; i++) table[norm(mods + i)] = [INDEXED[action], { index: i }];
    } else if (ACTIONS[action]) {
      table[norm(key)] = ACTIONS[action];
    }
  }
  return table;
}

// One JSON-RPC call to herdr-core, which keeps the app's spaces/tabs/splits
// in its "herdr-app" document.
async function rpc(method, params) {
  const req = JSON.stringify({ jsonrpc: "2.0", id: 1, method, params });
  const r = await exec("sh", ["-c", 'printf "%s\\n" "$1" | hc connect', "sh", req]);
  const res = r.stdout.split("\n").filter(Boolean).map((l) => JSON.parse(l)).find((m) => m.id === 1);
  if (!res || res.error) throw new Error(res?.error?.message ?? (r.stderr || "no reply from hc"));
  return res.result;
}

const STEP = 0.05; // share of the split moved per press
const MIN = 0.05;  // smallest share a pane keeps

// Moves the border of the focused pane's nearest row (left/right) or
// column (up/down) split one STEP that way, tmux resize-pane style.
// Mutates `value`; returns whether anything changed.
function resizeDoc(value, pane, dir) {
  const want = dir === "left" || dir === "right" ? "row" : "column";
  const find = (node, path) => {
    if (node.id === pane) return path;
    for (const c of node.children ?? []) {
      const p = find(c, [...path, node]);
      if (p) return p;
    }
    return null;
  };
  for (const space of value?.spaces ?? []) {
    for (const tab of space.tabs ?? []) {
      const path = find(tab.root, []);
      if (!path) continue;
      const chain = [...path, null];
      for (let i = path.length - 1; i >= 0; i--) {
        const split = path[i];
        const kids = split.children;
        if (split.type !== want || kids.length < 2) continue;
        const idx = kids.indexOf(chain[i + 1] ?? kids.find((k) => k.id === pane));
        const w = kids.map((k) => k.size?.weight ?? 1);
        const total = w.reduce((a, b) => a + b, 0);
        const d = STEP * total, min = MIN * total;
        const back = dir === "left" || dir === "up";
        // the border moved: before this pane when there is one that way
        const a = back ? (idx > 0 ? idx - 1 : idx) : (idx < kids.length - 1 ? idx : idx - 1);
        const delta = back ? -d : d;
        if (w[a] + delta < min || w[a + 1] - delta < min) return false;
        w[a] += delta; w[a + 1] -= delta;
        kids.forEach((k, j) => { k.size = { ...k.size, weight: w[j] }; });
        return true;
      }
      return false;
    }
  }
  return false;
}

async function resize(dir) {
  const pane = focused()?.pane;
  if (!pane) return;
  for (let tries = 0; tries < 3; tries++) {
    const { value, version } = await rpc("doc.get", { name: "herdr-app" });
    if (!resizeDoc(value, pane, dir)) return;
    try { return await rpc("doc.set", { name: "herdr-app", value, version }); }
    catch (e) { if (!/conflict/.test(e.message)) throw e; } // the app wrote first: redo on its version
  }
}

async function load() {
  const keys = { ...DEFAULTS, ...parseKeys(await readTextFile(home() + "/.config/herdr/config.toml")) };
  return { prefix: norm(keys.prefix), label: keys.prefix, table: { ...buildTable(keys), ...APP_KEYS } };
}

export default class Prefix extends View {
  init(_props, cx) {
    this.label = "";
    this.config = load().then((c) => { this.label = c.label; cx.notify(); return c; });
    this.handle = cx.focus_handle();
    this.handle.focus();
  }

  // Herdr cancels a mod's pending work once its overlay closes, so
  // everything finishes before closeOverlay.
  async press(e) {
    const { prefix, table } = await this.config;
    const strokes = [e.keystroke];
    // "?" arrives as shift-/; the TUI spells it by the character
    if (e.key_char && e.modifiers?.shift) strokes.push(e.key_char, "shift-" + e.key_char);
    try {
      if (strokes.includes(prefix)) {
        const t = focused()?.terminal;
        if (t) await hc(["keys", t, prefix.replaceAll("-", "+")]);
        return;
      }
      const hit = strokes.map((s) => table[s.toLowerCase()]).find(Boolean);
      if (hit?.[0] === "resize") await resize(hit[1]);
      else if (hit) run(hit[0], hit[1] ?? {});
    } finally {
      closeOverlay(props().overlay);
    }
  }

  render(cx) {
    const t = theme();
    return h_flex()
      .id("prefix")
      .track_focus(this.handle)
      .on_key_down((e, cx) => {
        // a bare modifier press is part of the next chord, not the key
        if (["shift", "control", "ctrl", "alt", "cmd", "platform", "function", "fn"].includes(e.key)) return;
        cx.stop_propagation();
        this.press(e).catch((err) => notify({ title: "prefix", body: String(err?.message ?? err), level: "error" }));
      })
      .size_full()
      .px(14)
      .gap(8)
      .items_center()
      .bg(t.popover)
      .text_size(13)
      .text_color(t.foreground)
      .child(div().font_semibold().child(this.label || "prefix"))
      .child(div().text_color(t.dim).child("press a key · Esc cancels"));
  }
}
