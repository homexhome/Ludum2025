extends Area3D

@export var movemet_controller : EnemyMovementController
@export var health : Health
var on_cooldown : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func deal_damage(body):
	body.take_damage()
	

func _on_body_entered(body: Node3D) -> void:
	if !health.is_alive(): return
	if on_cooldown: return
	if body.is_in_group("PlayerGroup"):
		deal_damage(body)
		print("Damaged Player")
		on_cooldown = true
		movemet_controller.character.enemy_state = Enemy.STATE.NOT_ACTIVE
		movemet_controller.time_to_check = 2
		if is_inside_tree():
			await get_tree().create_timer(1.0).timeout
		on_cooldown = false
