class_name EnemyMovementController
extends Node

@export var nav_agent : NavigationAgent3D
@onready var character : CharacterBody3D = get_parent()

@export var player : Player
var target 


@export var anim_name_dash : String
@export var anim_name_death : String
@export var anim_name_run : String

@export var animation_player : AnimationPlayer
@export var health : Health

func _ready() -> void:
	player = get_tree().get_first_node_in_group("PlayerGroup")
	while player == null:
		player = get_tree().get_first_node_in_group("PlayerGroup")
		await get_tree().process_frame
	target = player

var time_to_check : float = 1

func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	if Session.get_if_paused(): return
	if Session.fog == Session.FOG_STATE.STOP : return
	
	if target == null: return
	if time_to_check <= 0:
		if character.enemy_state != Enemy.STATE.ACTIVE:
			if target.global_position.distance_to(character.global_position) <= Session.max_depth:
				character.enemy_state = Enemy.STATE.ACTIVE
				$"../FarSound".stop()
				$"../CloseSound".play()
			time_to_check = 1
	else:
		time_to_check -= delta

	if character.enemy_state == Enemy.STATE.NOT_ACTIVE: return

	if nav_agent.is_navigation_finished():
		nav_agent.target_position = target.global_position
		return
	
	var velocity = (nav_agent.get_next_path_position() - character.global_position).normalized() * character.entity_resource.speed
	velocity.y = character.velocity.y + character.get_gravity().y * delta
	character.velocity = velocity
	var _transofrm = character.global_transform.looking_at(target.global_position)
	character.global_transform = lerp(character.global_transform,_transofrm,delta * 3)
	character.move_and_slide()
	if health == null: return
	if health.is_alive() == false : return
	if animation_player != null:
		if animation_player.current_animation != anim_name_dash:
			animation_player.play(anim_name_dash)


func dead():
	if animation_player == null: return

	animation_player.stop()
	$"../FarSound".stop()
	$"../CloseSound".stop()
	$"../DeathSound".play()
	if anim_name_death != "":
		animation_player.play(anim_name_death)
	var timer : float = 0

	while timer < 5:
		character.velocity.y = character.velocity.y - character.get_gravity().y * get_physics_process_delta_time()
		timer += get_physics_process_delta_time()
		await get_tree().physics_frame

func update_position():
	if Session.get_if_paused(): return
	if Session.fog == Session.FOG_STATE.STOP : return
	
	if target == null: return
	nav_agent.target_position = target.global_position
