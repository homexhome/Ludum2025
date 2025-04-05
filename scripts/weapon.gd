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

func attack():
	_time_between_shots = weapon_resource.time_between_shots
	shot.emit()

func special_attack():
	_time_between_shots = weapon_resource.time_between_shots
	shot.emit()

func reload():
	if reloading: return
	reloading = true
	animation_player.play("reload")
	await animation_player.animation_finished
	_time_between_shots = 0.0
	reloading = false
	
