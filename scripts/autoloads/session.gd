extends Node


var min_depth : float = 5
var max_depth : float = 20
var depth_perception : float = 5 :
	set(value):
		depth_perception = clampf(value,min_depth,max_depth)
		
var player : CharacterBody3D

func _physics_process(delta: float) -> void:
	change_depth(-delta)

func get_depth_perceprion() -> float : 
	return depth_perception

func get_player() -> CharacterBody3D:
	return player
	
func set_player(_player : CharacterBody3D):
	player = _player
	
func change_depth(amount : float):
	depth_perception += amount
