# Settings Menu Lite — drop-in options screen for Godot 4 (free)

A ready-made **Settings** panel plus a `GameSettings` autoload that applies the
options to the engine and saves them to disk. Add the scene anywhere and you're
done — no boilerplate.

```gdscript
# Read or change settings from anywhere:
GameSettings.set_master_volume(0.5)   # 0.0 .. 1.0
GameSettings.set_fullscreen(true)
GameSettings.save_settings()          # writes user://settings.cfg

# ...next launch they're loaded and applied automatically.
```

Or just instance the included panel and listen for `closed`:

```gdscript
var menu := preload("res://addons/settings_menu/settings_menu.tscn").instantiate()
add_child(menu)
menu.closed.connect(func(): menu.queue_free())
```

The panel covers **master volume, fullscreen, VSync and window resolution**,
reads the current values on open, and persists them on **Apply**. Run the
included demo (`demo/demo.tscn`) and press **Open Settings**.

## Install
1. Copy the `addons/settings_menu` folder into your project.
2. Enable **Settings Menu Lite** in *Project → Project Settings → Plugins*
   (this registers the `GameSettings` autoload).
3. Instance `settings_menu.tscn`, or call `GameSettings.*` directly.

## Lite vs PRO

| Feature | Lite (free) | **PRO** |
|---|:---:|:---:|
| Master volume | ✅ | ✅ |
| Fullscreen toggle | ✅ | ✅ |
| VSync toggle | ✅ | ✅ |
| Window resolution | ✅ | ✅ |
| Save / load to disk | ✅ | ✅ |
| **Separate Music / SFX buses** | — | ✅ |
| **Key & gamepad remapping** | — | ✅ |
| **Tabbed UI (Video / Audio / Controls)** | — | ✅ |
| **Localization-ready labels** | — | ✅ |

PRO is the same `GameSettings` autoload and `class_name` — just drop it in.
**Get Settings Menu PRO:**
👉 https://godot-forge.itch.io/settings-menu-godot

## License
MIT — free for commercial and personal projects. See `LICENSE.txt`.

Made by **GodotForge** · more Godot tools: https://godot-forge.itch.io
