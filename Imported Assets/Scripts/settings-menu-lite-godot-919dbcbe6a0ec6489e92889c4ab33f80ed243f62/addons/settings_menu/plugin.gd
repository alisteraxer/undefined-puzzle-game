@tool
extends EditorPlugin

const AUTOLOAD_NAME := "GameSettings"
const AUTOLOAD_PATH := "res://addons/settings_menu/game_settings.gd"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
