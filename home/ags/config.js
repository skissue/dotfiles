const updateCss = () => {
  const scss = `${App.configDir}/style.scss`;
  const css = `/tmp/ags-style.css`;

  Utils.exec(`sassc ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
};

updateCss();

Utils.monitorFile(`${App.configDir}/style.scss`, updateCss);

const hyprland = await Service.import("hyprland");

const dispatch = (ws) => hyprland.messageAsync(`dispatch workspace ${ws}`);

const Workspace = (ws) => {
  const data = hyprland.getWorkspace(ws);
  const active = data !== undefined;
  const indicator = active ? "●" : "○";
  const focused = hyprland.active.workspace.id === ws;

  return Widget.Button({
    className: focused ? "focused" : active ? "active" : "",
    label: indicator,
    onClicked: () => dispatch(ws),
  });
};

const Workspaces = Widget.EventBox({
  className: "workspaces",
  onScrollUp: () => dispatch("m+1"),
  onScrollDown: () => dispatch("m-1"),

  child: Widget.Box({
    vertical: true,
    // HACK There has to be a better way to do this...
    children: Array.from({ length: 10 }, (_, i) => i + 1).map(Workspace),
    setup: (self) =>
    self.hook(hyprland.active.workspace, (self) => {
      self.children = Array.from({ length: 10 }, (_, i) => i + 1).map(
        Workspace,
      );
    }),
  }),
});

const mpris = await Service.import("mpris");

const MusicStatus = Widget.Button({
  className: "segment",
  onClicked: mpris.bind("players").as((p) => () => p?.[0].playPause()),
  visible: mpris.bind("players").as((p) => p.length > 1), // playerctld always runs
}).hook(mpris, (self) => {
  const p = mpris.players;
  if (p.length <= 1) {
    // playerctd always runs
    self.visible = false;
    return;
  }
  self.visible = true;
  self.child = Widget.Box({
    vertical: true,
    children: [
      Widget.Label({
        xalign: 0.55,
      }).hook(p[0], (self) => {
        self.label = p[0].playBackStatus === "Playing" ? "󰏤" : "󰐊";
      }),
      Widget.Label({
        className: "icon",
        label: "󰝚",
        xalign: 0.45,
      }),
    ],
  });
});

const divide = ([total, free]) => free / total;

const cpu = Variable(0, {
  poll: [
    2000,
    "top -b -n 1",
    (out) =>
    divide([
      100,
      out
        .split("\n")
        .find((line) => line.includes("Cpu(s)"))
        .split(/\s+/)[1]
        .replace(",", "."),
    ]),
  ],
});

const ram = Variable(0, {
  poll: [
    2000,
    "free",
    (out) =>
    divide(
      out
        .split("\n")
        .find((line) => line.includes("Mem:"))
        .split(/\s+/)
        .splice(1, 2),
    ),
  ],
});

const Stat = (value, icon) =>
      Widget.Box({
        className: "segment",
        vertical: true,
        tooltipText: value.bind().as((v) => `${(v * 100).toFixed(1)}%`),
        children: [
          Widget.CircularProgress({
            classNames: value.bind().as((v) => {
              const color =
                    v > 0.8 ? "red" : v > 0.6 ? "orange" : v > 0.4 ? "yellow" : "";
              return ["stat", color];
            }),
            startAt: 0.75,
            value: value.bind(),
          }),
          Widget.Label({ className: "icon", label: icon, xalign: 0.45 }),
        ],
      });

const battery = await Service.import("battery");

const BatteryIndicator = Widget.Box({
  className: "segment",
  vertical: true,
  visible: battery.bind("available"),
  tooltipText: battery.bind("percent").as((p) => `${p}%`),
  children: [
    Widget.CircularProgress({
      classNames: battery.bind("percent").as((v) => {
        const color = battery.charging ? "green" : v < 20 ? "red" : v < 40 ? "orange" : "";
        return ["stat", color];
      }),
      startAt: 0.75,
      value: battery.bind("percent").as((p) => p / 100),
    }),
    Widget.Icon({
      icon: battery.bind('icon_name')
    }),
  ],
});

const systemtray = await Service.import("systemtray");

const SystrayItem = (item) =>
      Widget.Button({
        child: Widget.Icon().bind("icon", item, "icon"),
        tooltipMarkup: item.bind("tooltip_markup"),
        onPrimaryClick: (_, event) => item.activate(event),
        onSecondaryClick: (_, event) => item.openMenu(event),
      });

const Systray = Widget.Box({
  classNames: ["segment", "systray"],
  vertical: true,
  children: systemtray.bind("items").as((i) => i.map(SystrayItem)),
  visible: systemtray.bind("items").as((i) => i.length > 0),
});

const Clock = Widget.Box({
  classNames: ["segment", "clock"],
  vertical: true,
}).poll(1000, (self) => {
  const date = new Date();
  self.children = ["getHours", "getMinutes", "getSeconds"].map((f) =>
    Widget.Label({
      label: date[f]().toString().padStart(2, "0"),
      xalign: 0.54, // For some reason this is ever so slightly off center by default
    }),
  );
});

const Bar = Widget.Window({
  name: "bar",
  exclusivity: "exclusive",
  anchor: ["left", "top", "bottom"],
  margins: [6, 2, 6, 6],
  monitor: 0,
  child: Widget.CenterBox({
    vertical: true,
    startWidget: Workspaces,
    endWidget: Widget.Box({
      vertical: true,
      vpack: "end",
      children: [MusicStatus, Stat(cpu, "󰘚"), Stat(ram, "󰍛"), BatteryIndicator, Systray, Clock],
    }),
  }),
});

const players = mpris.bind("players")

const FALLBACK_ICON = "audio-x-generic-symbolic"
const PLAY_ICON = "media-playback-start-symbolic"
const PAUSE_ICON = "media-playback-pause-symbolic"
const PREV_ICON = "media-skip-backward-symbolic"
const NEXT_ICON = "media-skip-forward-symbolic"

const lengthStr = (length) => {
  const min = Math.floor(length / 60)
  const sec = Math.floor(length % 60)
  const sec0 = sec < 10 ? "0" : ""
  return `${min}:${sec0}${sec}`
}

const Player = (player) => {
  const img = Widget.Box({
    class_name: "img",
    vpack: "start",
    css: player.bind("cover_path").transform(p => `
            background-image: url('${p}');
        `),
  })

  const title = Widget.Label({
    class_name: "title",
    wrap: true,
    hpack: "start",
    label: player.bind("track_title"),
  })

  const artist = Widget.Label({
    class_name: "artist",
    wrap: true,
    hpack: "start",
    label: player.bind("track_artists").transform(a => a.join(", ")),
  })

  const positionSlider = Widget.Slider({
    class_name: "position",
    draw_value: false,
    on_change: ({ value }) => player.position = value * player.length,
    setup: self => {
      const update = () => {
        self.visible = player.length > 0
        self.value = player.position / player.length
      }
      self.hook(player, update)
      self.hook(player, update, "position")
      self.poll(1000, update)
    },
  })

  const positionLabel = Widget.Label({
    class_name: "position",
    hpack: "start",
    setup: self => {
      const update = (_, time) => {
        self.label = lengthStr(time || player.position)
        self.visible = player.length > 0
      }

      self.hook(player, update, "position")
      self.poll(1000, update)
    },
  })

  const lengthLabel = Widget.Label({
    class_name: "length",
    hpack: "end",
    visible: player.bind("length").transform(l => l > 0),
    label: player.bind("length").transform(lengthStr),
  })

  const icon = Widget.Icon({
    class_name: "icon",
    hexpand: true,
    hpack: "end",
    vpack: "start",
    tooltip_text: player.identity || "",
    icon: player.bind("entry").transform(entry => {
      const name = `${entry}-symbolic`
      return Utils.lookUpIcon(name) ? name : FALLBACK_ICON
    }),
  })

  const playPause = Widget.Button({
    class_name: "play-pause",
    on_clicked: () => player.playPause(),
    visible: player.bind("can_play"),
    child: Widget.Icon({
      icon: player.bind("play_back_status").transform(s => {
        switch (s) {
        case "Playing": return PAUSE_ICON
        case "Paused":
        case "Stopped": return PLAY_ICON
        }
      }),
    }),
  })

  const prev = Widget.Button({
    on_clicked: () => player.previous(),
    visible: player.bind("can_go_prev"),
    child: Widget.Icon(PREV_ICON),
  })

  const next = Widget.Button({
    on_clicked: () => player.next(),
    visible: player.bind("can_go_next"),
    child: Widget.Icon(NEXT_ICON),
  })

  return Widget.Box(
    { class_name: "player" },
    img,
    Widget.Box(
      {
        vertical: true,
        hexpand: true,
      },
      Widget.Box([
        title,
        icon,
      ]),
      artist,
      Widget.Box({ vexpand: true }),
      positionSlider,
      Widget.CenterBox({
        start_widget: positionLabel,
        center_widget: Widget.Box([
          prev,
          playPause,
          next,
        ]),
        end_widget: lengthLabel,
      }),
    ),
  )
}

const Music = Widget.Window({
  name: "music",
  layer: "bottom",
  anchor: ["top", "right"],
  margins: [24, 24, 0, 0],
  monitor: 0,
  child: Widget.Box({
    vertical: true,
    visible: players.as(p => p.length > 1),
  }).hook(mpris, self => {
    self.children = [Player(mpris.players[0])];
  }),
})

App.config({ windows: [Bar, Music] });
