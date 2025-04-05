extends Node

@export var loader_place : Node3D
@export var level_scene : PackedScene
@export var player_scene : PackedScene

var level : Level
var player : Player

func _ready() -> void:
	start_game()

func start_game():
	Session.stop_fog()
	level = level_scene.instantiate()
	loader_place.add_child(level)
	
	player = player_scene.instantiate()
	level.add_child(player)
	player.global_position = level.get_player_spawn()
	Session.resume_player()

	await get_tree().create_timer(5.0).timeout
	Session.start_fog()
	await get_tree().create_timer(1.0).timeout
	player.give_gun()
