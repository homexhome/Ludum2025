extends Node

func _ready() -> void:
	Session.flush_session()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func start_game():
	get_tree().change_scene_to_packed(load("res://scenes/game.tscn"))
