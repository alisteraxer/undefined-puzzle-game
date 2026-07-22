extends Control
## Settings Menu Lite — demo.
## Press the button to open the ready-made SettingsMenu. It reads/writes the
## GameSettings autoload and saves to disk on Apply.

const SettingsMenuScene := preload("res://addons/settings_menu/settings_menu.tscn")

@onready var _open_button: Button = $Center/VBox/OpenButton
@onready var _status: Label = $Center/VBox/Status

var _menu: SettingsMenu


func _ready() -> void:
	_open_button.pressed.connect(_open_settings)
	_refresh_status()


func _open_settings() -> void:
	if is_instance_valid(_menu):
		return
	_menu = SettingsMenuScene.instantiate()
	add_child(_menu)
	_menu.closed.connect(_on_settings_closed)


func _on_settings_closed() -> void:
	if is_instance_valid(_menu):
		_menu.queue_free()
		_menu = null
	_refresh_status()


func _refresh_status() -> void:
	_status.text = "Volume %d%%   Fullscreen %s   VSync %s   %dx%d" % [
		roundi(GameSettings.master_volume * 100.0),
		"on" if GameSettings.fullscreen else "off",
		"on" if GameSettings.vsync else "off",
		GameSettings.resolution.x, GameSettings.resolution.y,
	]
