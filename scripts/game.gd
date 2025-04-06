extends Node

@export var loader_place : Node3D
@export var level_scene : PackedScene
@export var player_scene : PackedScene


@export var god : Node3D
var level : Level
var player : Player

func _ready() -> void:
	start_game()
	Session.end_game.connect(end_game)

func start_game():
	Session.stop_fog()
	level = level_scene.instantiate()
	loader_place.add_child(level)
	
	player = player_scene.instantiate()
	level.add_child(player)
	player.global_position = level.get_player_spawn()
	Session.resume_player()

	await get_tree().create_timer(8.0).timeout
	Session.start_fog()

	await Session.fog_on
	await get_tree().create_timer(1.0).timeout
	
	player.give_gun()
	player.died.connect(go_back_to_menu)

func end_game():
	god.show()
	Session.pause_player()
	var needed_transfrom = player.global_transform.looking_at(god.look_pos.global_position)
	while player.global_transform.is_equal_approx(needed_transfrom):
		player.global_transform = lerp(player.global_transform,needed_transfrom,get_process_delta_time() * 3)
		await get_tree().process_frame

func go_back_to_menu():
	get_tree().call_deferred("change_scene_to_file","res://scenes/main_menu.tscn")
