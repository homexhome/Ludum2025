class_name Health
extends Area3D

var max_health : float = 30
var current_health : float = 30

@export var override_take_damage : bool = false
@export var damaged_particle : PackedScene

signal dead
signal damaged

func _ready() -> void:
	max_health = get_parent().entity_resource.max_health
	current_health = max_health
	
func take_damage(damage : float, hit_position : Vector3):
	if override_take_damage: dead.emit()
	if !is_alive(): return
	if get_parent() is CharacterBody3D and get_parent().is_on_floor() == false:
		damage *= 2
	current_health -= damage
	
	if damaged_particle != null:
		var particle : GPUParticles3D = damaged_particle.instantiate()
		add_child(particle)
		particle.global_position = hit_position
		particle.set_emitting(true)
		particle.finished.connect(particle.queue_free)
	
	if !is_alive():
		print(get_parent(), " died!")
		dead.emit()
		Session.change_depth(Session.kill_amount)
	else:
		damaged.emit()
		Session.change_depth(Session.damage_amound)
		var _par = get_parent()
		var dir = ((_par.global_position + Vector3.UP * 0.2) - Vector3(_par.global_position)).normalized()
		_par.velocity = dir * _par.hit_impulse_power

func is_alive():
	return current_health > 0 
