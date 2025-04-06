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
	$Start.play()
	player.give_gun()
	player.died.connect(go_back_to_menu)

func end_game():
	god.show()
	god.health.dead.connect(really_end_game)
	Session.pause_player()
	var cam = player.camera
	var needed_transfrom = cam.global_transform.looking_at(god.look_pos.global_position)
	var time : float = 0.0
	$End.play()
	while cam.global_transform.is_equal_approx(needed_transfrom) == false:
		cam.global_transform = lerp(cam.global_transform,needed_transfrom,get_process_delta_time() * 3)
		time += get_process_delta_time()
		if time >= 3.0:
			break
		await get_tree().process_frame
	#await get_tree().create_timer(2.0).timeout
	Session.resume_player()
	Session.environment.environment.fog_enabled = false
	$TextureRect.show()
	god.health.monitoring = true
	god.health.monitorable = true

func really_end_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().call_deferred("change_scene_to_file","res://scenes/main_menu.tscn")

func go_back_to_menu():
	get_tree().call_deferred("change_scene_to_file","res://scenes/main_menu.tscn")
