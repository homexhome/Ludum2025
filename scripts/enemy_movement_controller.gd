extends Node

@export var nav_agent : NavigationAgent3D
@onready var character : CharacterBody3D = get_parent()

@export var player : Player
var target 

func _ready() -> void:
	player = get_tree().get_first_node_in_group("PlayerGroup")
	if player == null:
		push_error("PlayerGroup or Player is missing")
	else:
		target = player

func _physics_process(delta: float) -> void:
	if target == null:
		return
		
	if nav_agent.is_navigation_finished():
		nav_agent.target_position = target.global_position
		return
	
	var velocity = (nav_agent.get_next_path_position() - character.global_position).normalized() * character.enemy_resource.speed
	velocity.y = character.velocity.y + character.get_gravity().y * delta
	character.velocity = velocity
	print(character.velocity.y)
	character.move_and_slide()
