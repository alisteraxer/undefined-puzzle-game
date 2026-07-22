class_name SettingsMenu
extends Control
## Ready-made settings panel (Settings Menu Lite). Reads/writes the GameSettings
## autoload and persists on Apply. Instance `settings_menu.tscn` anywhere, or add
## this script to your own Control with matching child node names.
##
## Emits `closed` when the player presses Back. PRO version adds tabs, audio buses,
## input remapping and localization. -> https://godot-forge.itch.io/settings-menu-godot

signal closed

@onready var _volume: HSlider = %VolumeSlider
@onready var _fullscreen: CheckButton = %FullscreenCheck
@onready var _vsync: CheckButton = %VSyncCheck
@onready var _resolution: OptionButton = %ResolutionOption


func _ready() -> void:
	_populate_resolutions()
	_pull_from_settings()
	_volume.value_changed.connect(_on_volume_changed)
	_fullscreen.toggled.connect(_on_fullscreen_toggled)
	_vsync.toggled.connect(_on_vsync_toggled)
	_resolution.item_selected.connect(_on_resolution_selected)
	%ApplyButton.pressed.connect(_on_apply)
	%BackButton.pressed.connect(_on_back)


func _populate_resolutions() -> void:
	_resolution.clear()
	for res in GameSettings.RESOLUTIONS:
		_resolution.add_item("%d x %d" % [res.x, res.y])


func _pull_from_settings() -> void:
	_volume.min_value = 0.0
	_volume.max_value = 1.0
	_volume.step = 0.01
	_volume.value = GameSettings.master_volume
	_fullscreen.button_pressed = GameSettings.fullscreen
	_vsync.button_pressed = GameSettings.vsync
	var idx := GameSettings.RESOLUTIONS.find(GameSettings.resolution)
	if idx >= 0:
		_resolution.select(idx)


# ---------------------------------------------------------------- signals
func _on_volume_changed(value: float) -> void:
	GameSettings.set_master_volume(value)


func _on_fullscreen_toggled(pressed: bool) -> void:
	GameSettings.set_fullscreen(pressed)
	# resolution only matters in windowed mode
	_resolution.disabled = pressed


func _on_vsync_toggled(pressed: bool) -> void:
	GameSettings.set_vsync(pressed)


func _on_resolution_selected(index: int) -> void:
	if index >= 0 and index < GameSettings.RESOLUTIONS.size():
		GameSettings.set_resolution(GameSettings.RESOLUTIONS[index])


func _on_apply() -> void:
	GameSettings.apply_all()
	GameSettings.save_settings()


func _on_back() -> void:
	closed.emit()
