class_name Health
extends Area3D

var max_health : float = 30
var current_health : float = 30

@export var damaged_particle : PackedScene

signal dead


func _ready() -> void:
	max_health = get_parent().entity_resource.max_health
	current_health = max_health
	
func take_damage(damage : float, hit_position : Vector3):
	if !is_alive(): return
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

func is_alive():
	return current_health > 0 
