class_name Player
extends CharacterBody3D

var current_weapon : Weapon

@export var gun_scene : PackedScene
@export var gun_place : Node3D

@export var camera : Camera3D
var health : int = 5 : 
	set(value):
		health = value
		health_changed.emit()
var max_health : int = 5

signal died
signal health_changed

func _ready() -> void:
	if is_instance_valid(current_weapon): 
		current_weapon.queue_free()
	Session.set_player(self)
	Session.gold_added.connect(regenerate)
	

func give_gun():
	current_weapon = gun_scene.instantiate()
	gun_place.add_child(current_weapon)
	current_weapon._reload.connect(spawn_ammo)

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
		rotation_degrees.x += get_process_delta_time() * 30
		await get_tree().process_frame
	died.emit()

@export var empty_ammo : PackedScene
@export var empty_ammo_signle : PackedScene

func spawn_ammo():
	var pos = global_position
	var query = PhysicsRayQueryParameters3D.create(global_position + Vector3.UP, global_position - Vector3.DOWN * 100, 1, [get_rid()])
	var dir_space = get_world_3d().direct_space_state
	var result = dir_space.intersect_ray(query)
	if result.has("position"):
		pos = result["position"]
	
	var _ammo = empty_ammo.instantiate()
	get_parent().add_child(_ammo)
	_ammo.global_position = pos
	
func spawn_ammo_single():
	var pos = global_position
	var query = PhysicsRayQueryParameters3D.create(global_position + Vector3.UP, (global_position + Vector3.UP) + Vector3.DOWN * 100, 1, [get_rid()])
	var dir_space = get_world_3d().direct_space_state
	var result = dir_space.intersect_ray(query)
	if result.has("position"):
		pos = result["position"]
	
	var _ammo = empty_ammo_signle.instantiate()
	get_parent().add_child(_ammo)
	_ammo.global_position = pos
