class_name Player
extends CharacterBody3D

var current_weapon : Weapon

@export var gun_scene : PackedScene
@export var gun_place : Node3D

var health : int = 5
var max_health : int = 5

signal died

func _ready() -> void:
	if is_instance_valid(current_weapon): 
		current_weapon.queue_free()
	Session.set_player(self)
	

func give_gun():
	current_weapon = gun_scene.instantiate()
	gun_place.add_child(current_weapon)

func is_alive():
	return health > 0

func take_damage():
	if !is_alive(): return
	health -= 1
	if health <= 0:
		await death()
	else:
		$DeathSound.pitch_scale = randf_range(0.5,0.8)
		$DeathSound.play()
	

func regenerate():
	if health >= max_health: return
	health += 1

func death():
	Session.pause_player()
	if is_instance_valid(current_weapon): 
		current_weapon.queue_free()
	$DeathSound.pitch_scale = 1.5
	$DeathSound.play()
	while rotation_degrees.x <= 90:
		rotation_degrees.x += get_process_delta_time() * 10
		await get_tree().process_frame
	died.emit()
