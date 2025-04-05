class_name Player
extends CharacterBody3D

var current_weapon : Weapon

@export var gun_scene : PackedScene
@export var gun_place : Node3D

func _ready() -> void:
	if is_instance_valid(current_weapon): 
		current_weapon.queue_free()
	Session.set_player(self)
	

func give_gun():
	current_weapon = gun_scene.instantiate()
	gun_place.add_child(current_weapon)
