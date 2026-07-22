extends Node
## GameSettings — autoload singleton (Settings Menu Lite).
## Holds the player's options, applies them to the engine, and persists them to
## disk as a ConfigFile. Drop-in: enable the plugin and call GameSettings.* or
## open the included SettingsMenu scene.
##
## Lite covers: master volume, fullscreen, VSync and window resolution.
## PRO adds: separate Music/SFX audio buses, key & gamepad remapping, a tabbed
## UI and localization. -> https://godot-forge.itch.io/settings-menu-godot

signal settings_applied
signal settings_loaded

const SETTINGS_PATH := "user://settings.cfg"

## Common 16:9 resolutions offered by the Lite menu.
const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
]

var master_volume: float = 1.0   # 0.0 .. 1.0 (linear)
var fullscreen: bool = false
var vsync: bool = true
var resolution: Vector2i = Vector2i(1920, 1080)


func _ready() -> void:
	load_settings()
	apply_all()


# ---------------------------------------------------------------- setters
func set_master_volume(value: float) -> void:
	master_volume = clampf(value, 0.0, 1.0)
	_apply_volume()


func set_fullscreen(value: bool) -> void:
	fullscreen = value
	_apply_window()


func set_vsync(value: bool) -> void:
	vsync = value
	_apply_vsync()


func set_resolution(value: Vector2i) -> void:
	resolution = value
	_apply_window()


# ---------------------------------------------------------------- apply
func apply_all() -> void:
	_apply_volume()
	_apply_vsync()
	_apply_window()
	settings_applied.emit()


func _is_headless() -> bool:
	return DisplayServer.get_name() == "headless"


func _apply_volume() -> void:
	var bus := AudioServer.get_bus_index("Master")
	if bus < 0:
		bus = 0
	AudioServer.set_bus_volume_db(bus, linear_to_db(master_volume))


func _apply_vsync() -> void:
	if _is_headless():
		return
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)


func _apply_window() -> void:
	if _is_headless():
		return
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(resolution)


# ---------------------------------------------------------------- persistence
func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "master_volume", master_volume)
	cfg.set_value("video", "fullscreen", fullscreen)
	cfg.set_value("video", "vsync", vsync)
	cfg.set_value("video", "resolution", resolution)
	cfg.save(SETTINGS_PATH)


func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return  # first run: keep defaults
	master_volume = clampf(cfg.get_value("audio", "master_volume", master_volume), 0.0, 1.0)
	fullscreen = cfg.get_value("video", "fullscreen", fullscreen)
	vsync = cfg.get_value("video", "vsync", vsync)
	resolution = cfg.get_value("video", "resolution", resolution)
	settings_loaded.emit()


func reset_to_defaults() -> void:
	master_volume = 1.0
	fullscreen = false
	vsync = true
	resolution = Vector2i(1920, 1080)
	apply_all()
