extends Node


func start_game():
	get_tree().change_scene_to_packed(load("res://scenes/game.tscn"))
