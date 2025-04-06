class_name PlayerController
extends Node3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var player : CharacterBody3D
@export var camera : Camera3D
#@export var active_weapon : Weapon

var step_time : float = 0.5
signal step
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	# Handle jump.
	if Session.get_if_paused(): return

	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, camera.rotation.y)).normalized()
	if direction:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
		step_time -= delta
		if step_time <= 0:
			if player.is_on_floor():
				step.emit()
				step_time = 0.5
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
		step_time = 0.0

	player.move_and_slide()
