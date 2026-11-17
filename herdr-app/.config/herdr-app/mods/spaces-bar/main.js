// Top bar: spaces as pills (click to switch, double-click to rename, right-click
// for its menu, drag to reorder), a + for a new space, and the Files/Changes
// panel toggles. With props {tabs: true} a second row shows the active space's
// tabs, the active space's pill joined to it like a folder tab; without it,
// tabs live elsewhere (the tabs-side sidebar).

import { View, div, svg, image } from "gpui-kit";
import { h_flex, v_flex, ScrollHandle } from "gpui-base";
import { spaces, panes, props, run, openOverlay, theme, window, shared, setShared, layout } from "herdr";

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

// Same avatar colors as the shipped spaces mod, shared through "space.colors".
const MARK = { ansi6: "#22a99a", ansi3: "#e3814f", ansi4: "#5b8def", ansi5: "#8b7cf6", ansi2: "#3fae6a", ansi1: "#d9649a" };
const PALETTE = ["ansi6", "ansi3", "ansi4", "ansi5", "ansi2", "ansi1"];

function assignColors(sp) {
  const stored = shared("space.colors") ?? {};
  const ids = new Set(sp.map((s) => s.id));
  const kept = Object.fromEntries(Object.entries(stored).filter(([id]) => ids.has(id)));
  let changed = Object.keys(kept).length !== Object.keys(stored).length;
  for (const s of sp) {
    if (kept[s.id] || s.name === "~") continue;
    const uses = (c) => Object.values(kept).filter((v) => v === c).length;
    kept[s.id] = PALETTE.reduce((best, c) => (uses(c) < uses(best) ? c : best));
    changed = true;
  }
  if (changed) setShared("space.colors", kept);
  return kept;
}

// Same as the shipped tabs mod: drops a status glyph, keeps a leading bracket or quote.
const clean = (s) => (s ?? "").replace(/^[^\p{L}\p{N}\p{Ps}\p{Pi}]+/u, "").replace(/^\[ [!.] \] /, "").trim();

// A tab Herdr named follows its agent's live title; a name the person gave stays.
function label(tab, lead) {
  const prog = lead?.program?.name;
  const base = tab.named ? tab.name : prog ?? "Terminal";
  if (!lead?.program?.agent) return base;
  const live = clean(lead.title);
  const path = /^[~/]|^[A-Za-z]:\\/.test((lead.title ?? "").replace(/^[^\p{L}\p{N}~/]+/u, ""));
  const telling = live && live !== lead.terminal && live !== prog && !path && !live.includes("@") && live.toLowerCase() !== lead.program.key;
  return (tab.name === prog || !tab.named) && telling ? live : base;
}

export default class SpacesBar extends View {
  init() {
    this.pressed = null;
    this.tabPressed = null;
    this.scroll = ScrollHandle.new();
    this.tabScroll = ScrollHandle.new();
    try { this.panels = JSON.parse(localStorage.getItem("panels") ?? "{}"); } catch { this.panels = {}; }
    if (!this.panels || typeof this.panels !== "object" || Array.isArray(this.panels)) this.panels = {};
  }

  // The side panel is remembered per space, as in the shipped tabs mod.
  syncPanel(space, panel, body, enabled) {
    if (!space || !panel) return;
    const now = panel.hidden ? null : body?.active ?? null;
    if (space.id !== this.space) {
      const first = this.space === undefined;
      this.space = space.id; this.pending = null;
      if (!(first && !(space.id in this.panels))) {
        const stored = this.panels[space.id] ?? null, want = enabled.includes(stored) ? stored : null;
        if (want !== now) {
          this.pending = { want, until: Date.now() + 1000 };
          if (want) { run("layout.select", { stack: "panel-body", child: want }); run("layout.show", { id: "panel" }); }
          else run("layout.hide", { id: "panel" });
          return;
        }
      }
    }
    if (this.pending) {
      if (this.pending.want !== now && Date.now() < this.pending.until) return;
      this.pending = null;
    }
    if (this.panels[space.id] === now) return;
    this.panels[space.id] = now;
    localStorage.setItem("panels", JSON.stringify(this.panels));
  }

  render() {
    const t = theme();
    const sp = spaces();
    const withTabs = Boolean(props()?.tabs);
    const colors = assignColors(sp);
    const space = sp.find((s) => s.active);
    const active = sp.findIndex((s) => s.active);
    if (active !== this.revealed) {
      this.revealed = active;
      if (active >= 0) this.scroll.scroll_to_item(active);
    }
    const stop = (_e, cx) => cx.stop_propagation();
    const button = (id, label, action) => div().id(id).size(26).flex_none().flex().items_center().justify_center().rounded(6)
      .text_color(t.dim).hover((s) => s.bg(t.hover).text_color(t.foreground))
      .on_mouse_down("left", stop).on_click(action).child(label);

    const pill = (s, i) => {
      const color = colors[s.id] ?? "ansi6";
      const fill = color.startsWith("#") ? color : MARK[color] ?? t[color];
      const from = this.pressed === null ? null : sp[this.pressed];
      const joined = withTabs && s.active;
      return h_flex().id(`space-${s.id}`).px(8).gap(7).items_center().flex_none().text_size(12.8)
        .when(joined, (el) => el.h(34).rounded_t(8).border_t(1).border_l(1).border_r(1).border_color(t.border).bg(t.raised).text_color(t.foreground))
        .when(!joined, (el) => el.h(29).rounded(7).border(1).when(withTabs, (e) => e.mb(4))
          .border_color(s.active ? t.border : t.chrome).bg(s.active ? t.raised : t.chrome)
          .text_color(s.active ? t.foreground : t.muted).hover((st) => st.bg(t.hover)))
        .on_mouse_down("left", (e, cx) => { cx.stop_propagation(); this.pressed = i; if (e.click_count === 2) run("space.rename", { id: s.id }); })
        .on_mouse_up("left", () => {
          this.pressed = null;
          // Reorder only within one machine, as the spaces sidebar does.
          if (from && from.id !== s.id && (from.machine ?? null) === (s.machine ?? null)) run("space.move", { id: from.id, index: i + 1 });
          else run("space.select", { id: s.id });
        })
        .on_mouse_down("right", (_e, cx) => { cx.stop_propagation(); openOverlay({ mod: "menu", kind: "popup", width: 200, height: 260, props: { tab: "space", target: { id: s.id } } }); })
        .child(h_flex().size(18).flex_none().rounded(5).bg(fill).items_center().justify_center().text_size(10.5).font_bold().text_color("#ffffff")
          .child([...s.name][0]?.toUpperCase() ?? "?"))
        .child(div().max_w(180).truncate().child(s.machine ? `${s.name} @${s.machine}` : s.name))
        .when(s.status === "working", (el) => el.child(svg("mods/workspace-chrome/spinner.svg").size(12).flex_none().text_color(t.working).spin(900)))
        .when(s.status === "blocked" || s.status === "done", (el) => el.child(div().size(6).rounded(3).bg(t[s.status])));
    };

    const root = layout(), w = window();
    const lights = w?.platform === "macos" && w.titlebar === "none" && !w.fullscreen && root?.traffic_lights;
    const panel = find(root, "panel"), body = find(root, "panel-body");
    const enabled = shared("workspace.panels") ?? ["files", "changes"];
    this.syncPanel(space, panel, body, enabled);
    const panelButton = (id, label, icon) => {
      const on = panel && !panel.hidden && body?.active === id;
      return h_flex().id(`panel-${id}`).h(26).px(8).gap(5).flex_none().items_center().rounded(6)
        .text_size(12).bg(on ? t.selected : t.chrome).text_color(on ? t.foreground : t.muted)
        .hover((s) => s.bg(t.hover)).on_mouse_down("left", stop)
        .on_click(() => {
          if (on) run("layout.hide", { id: "panel" });
          else { run("layout.select", { stack: "panel-body", child: id }); run("layout.show", { id: "panel" }); }
        }).child(svg(icon).size(14)).child(label);
    };

    const spaceRow = h_flex().w_full().min_w(0).px(10).pl(lights ? root.traffic_lights[0] + 68 : 10).gap(3)
      .bg(t.chrome).on_mouse_up("left", () => { this.pressed = null; })
      .when(withTabs, (el) => el.h(40).flex_none().items_end())
      .when(!withTabs, (el) => el.size_full().items_center().border_b(1).border_color(t.border))
      .child(h_flex().id("space-scroll").flex_1().min_w(0).h_full().gap(3).overflow_x_scrollbar().track_scroll(this.scroll)
        .when(withTabs, (el) => el.items_end()).when(!withTabs, (el) => el.items_center())
        .children(sp.map(pill)))
      .child(button("space-new", svg("mods/workspace-chrome/plus.svg").size(14), () => run("space.new")))
      .when(enabled.includes("files"), (el) => el.child(panelButton("files", "Files", "mods/files/file.svg")))
      .when(enabled.includes("changes"), (el) => el.child(panelButton("changes", "Changes", "mods/changes/changes.svg")))
      .when(Boolean(w?.buttons), (el) => el
        .child(button("minimize", "−", () => run("window.minimize")))
        .child(button("maximize", "□", () => run("window.maximize")))
        .child(button("close-window", svg("mods/pane/close.svg").size(13), () => run("window.close"))));
    if (!withTabs) return spaceRow;
    return v_flex().size_full().min_w(0).bg(t.chrome).child(spaceRow).child(this.tabRow(t, space, stop));
  }

  // The active space's tabs, on the same surface as its pill above.
  tabRow(t, space, stop) {
    const shown = space?.tabs ?? [];
    const active = shown.findIndex((c) => c.active);
    if (shown[active]?.id !== this.tabRevealed) {
      this.tabRevealed = shown[active]?.id;
      if (active >= 0) this.tabScroll.scroll_to_item(active);
    }
    const all = panes();
    const item = (c, i) => {
      const mine = all.filter((p) => p.tab === c.id);
      const lead = mine.find((p) => p.program?.agent) ?? mine[0];
      const program = lead?.program;
      const name = label(c, lead);
      return h_flex().id(`tab-${c.id}`).h(26).px(9).gap(7).rounded(6).items_center().flex_none().text_size(12.5)
        .border(1).border_color(c.active ? t.border : t.raised).bg(c.active ? t.background : t.raised)
        .text_color(c.active ? t.foreground : t.muted).hover((s) => s.bg(t.hover))
        .on_mouse_down("left", (e, cx) => { cx.stop_propagation(); this.tabPressed = i; if (e.click_count === 2) run("tab.rename", { id: c.id }); })
        .on_mouse_up("left", () => {
          const from = this.tabPressed; this.tabPressed = null;
          if (from !== null && from !== i) run("tab.move", { id: shown[from].id, index: i + 1 });
          else run("tab.select", { id: c.id });
        })
        .on_mouse_down("right", (_e, cx) => { cx.stop_propagation(); openOverlay({ mod: "menu", kind: "popup", width: 200, props: { tab: "tab", target: { id: c.id, space: space.id } } }); })
        .child(div().flex_none().text_size(11).text_color(t.dim).child(String(i + 1)))
        .when(Boolean(program?.icon), (el) => el.child(program.tint ? svg(program.icon).size(14).flex_none().text_color(t.muted) : image(program.icon).size(14).flex_none()))
        .child(div().max_w(200).truncate().child(c.zoomed ? `${name} Z` : name))
        .when(c.status === "working", (el) => el.child(svg("mods/workspace-chrome/spinner.svg").size(12).flex_none().text_color(t.working).spin(900)))
        .when(c.status === "blocked" || c.status === "done", (el) => el.child(div().size(6).flex_none().rounded(3).bg(t[c.status])))
        .when(c.active, (el) => el.child(div().id(`close-${c.id}`).flex_none().text_color(t.dim).hover((s) => s.text_color(t.foreground))
          .on_mouse_down("left", stop).on_click((_e, cx) => { cx.stop_propagation(); run("tab.close", { id: c.id }); })
          .child(svg("mods/pane/close.svg").size(12))));
    };
    return h_flex().flex_1().min_h(0).w_full().min_w(0).px(10).gap(3).items_center()
      .bg(t.raised).border_t(1).border_b(1).border_color(t.border)
      .on_mouse_up("left", () => { this.tabPressed = null; })
      .child(h_flex().id("tab-scroll").min_w(0).flex_shrink(1).h_full().items_center().gap(3).overflow_x_scrollbar().track_scroll(this.tabScroll)
        .children(shown.map(item)))
      .child(div().id("tab-new").size(24).flex_none().flex().items_center().justify_center().rounded(6).text_color(t.dim)
        .hover((s) => s.bg(t.hover).text_color(t.foreground)).on_mouse_down("left", stop)
        .on_click(() => openOverlay({ mod: "new-menu", kind: "popup", width: 250, height: 512 }))
        .child(svg("mods/workspace-chrome/plus.svg").size(13)));
  }
}
