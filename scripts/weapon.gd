extends Node3D
class_name Weapon

signal shot
signal special_shot

@export var weapon_resource : WeaponResource
var _time_between_shots : float = 0.0

@export var max_ammo : int = 2
var ammo : int = 0
var reloading : bool = false

@export var animation_player : AnimationPlayer

func _ready() -> void:
	ammo = max_ammo
	while Session.get_player() == null:
		await get_tree().process_frame
	Session.get_player().current_weapon = self

func _process(delta: float) -> void:
	_time_between_shots = clampf(_time_between_shots - delta, 0.0, weapon_resource.time_between_shots)
	if _time_between_shots == 0.0 and animation_player.current_animation != "Idle":
		animation_player.play("Idle")
		
func attack():
	_time_between_shots = weapon_resource.time_between_shots
	shot.emit()
	animation_player.play("Shoot")

func special_attack():
	_time_between_shots = weapon_resource.time_between_shots
	shot.emit()
	animation_player.play("Shoot")
	

func reload():
	if reloading: return
	reloading = true
	animation_player.play("Reload")
	await animation_player.animation_finished
	_time_between_shots = 0.0
	animation_player.play("Idle")
	
	reloading = false
	
