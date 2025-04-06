extends Node


var min_depth : float = 5
var max_depth : float = 20
var depth_perception : float = 5 :
	set(value):
		depth_perception = clampf(value,min_depth,max_depth)
		
var speed_of_depth : float = 2
var player : CharacterBody3D

var environment : WorldEnvironment

enum STATE {PAUSE, PLAY}
var session_state : STATE = STATE.PAUSE

var gold : int = 0

enum FOG_STATE {OK, STOP}
var fog : FOG_STATE = FOG_STATE.STOP

signal fog_on
signal end_game

func start_fog():
	while environment.environment.fog_depth_end > max_depth:
		environment.environment.fog_depth_end -= 1
		if environment.environment.fog_depth_begin > 0:
			environment.environment.fog_depth_begin = clampf(environment.environment.fog_depth_begin - 0.15, 0.0, 100)
		await get_tree().process_frame
	fog = FOG_STATE.OK
	fog_on.emit()
	environment.environment.fog_depth_begin = 0

func stop_fog():
	fog = FOG_STATE.STOP

func pause_player():
	session_state = STATE.PAUSE

func resume_player():
	session_state = STATE.PLAY

func get_if_paused() -> bool:
	return session_state == STATE.PAUSE

func flush_session():
	player = null
	session_state = STATE.PAUSE
	fog = FOG_STATE.STOP
	environment = null
	gold = 0

func _physics_process(delta: float) -> void:
	if fog == FOG_STATE.STOP: return
	change_depth(-delta * speed_of_depth)
	environment.environment.fog_depth_end = depth_perception
	
func get_depth_perceprion() -> float : 
	return depth_perception

func get_player() -> CharacterBody3D:
	return player
	
func set_player(_player : CharacterBody3D):
	player = _player
	
func change_depth(amount : float):
	depth_perception += amount

func set_environment(env : WorldEnvironment):
	environment = env

func get_environment() -> WorldEnvironment:
	return environment

func add_gold():
	gold += 1
	if gold >= 5:
		pause_player()
		stop_fog()
		while environment.environment.fog_depth_end < max_depth * 3:
			environment.environment.fog_depth_end += 1

			print(environment.environment.fog_depth_end, " ", environment.environment.fog_depth_begin)
			await get_tree().process_frame
	end_game.emit()
