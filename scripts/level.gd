class_name Level
extends Node3D

@export var player_spawn_location : Node3D


func get_player_spawn() -> Vector3:
	return player_spawn_location.global_position
