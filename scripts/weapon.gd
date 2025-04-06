extends Node3D
class_name Weapon

signal shot
signal _reload

@export var weapon_resource : WeaponResource
var _time_between_shots : float = 0.0

@export var max_ammo : int = 2
@export var amount_of_depth_change : float = 5
var ammo : int = 0
var reloading : bool = false

@export var animation_player : AnimationPlayer

@export var l_ammo : MeshInstance3D
@export var r_ammo : MeshInstance3D

func _ready() -> void:
	ammo = max_ammo
	while Session.get_player() == null:
		await get_tree().process_frame
	Session.get_player().current_weapon = self



func _process(delta: float) -> void:
	_time_between_shots = clampf(_time_between_shots - delta, 0.0, weapon_resource.time_between_shots)
	if _time_between_shots == 0.0 and animation_player.current_animation != "Idle" and reloading == false:
		animation_player.play("Idle")
	if Input.is_action_just_pressed("right_click") and reloading == false and _time_between_shots == 0.0:
		start_right_click()
	if Input.is_action_just_released("right_click") and reloading  and animation_player.assigned_animation == "CheckThisOut_3":
		end_right_click()

func attack():
	if ammo <= 0:
		reload()
		return
	ammo -= 1
	_time_between_shots = weapon_resource.time_between_shots
	shot.emit()
	animation_player.play("Shoot")
	Session.change_depth(amount_of_depth_change)

func special_attack():
	_time_between_shots = weapon_resource.time_between_shots
	shot.emit()
	animation_player.play("Shoot")
	

func start_right_click():
	reloading = true
	animation_player.play("CheckThisOut_3")
	if ammo == 2:
		l_ammo.show()
		r_ammo.show()
	elif  ammo == 1:
		l_ammo.hide()
		r_ammo.show()
	elif ammo == 0:
		l_ammo.hide()
		r_ammo.hide()
	$AudioStreamPlayer3D3.reload()

func end_right_click():
	$AudioStreamPlayer3D4.reload()
	animation_player.play("CheckThisOut_2")
	await animation_player.animation_finished
	l_ammo.show()
	r_ammo.show()
	reloading = false

func reload():
	if reloading: return
	if _time_between_shots > 0 : return
	reloading = true
	_reload.emit()
	animation_player.stop()
	animation_player.play("Reload")
	await animation_player.animation_finished
	ammo = max_ammo
	_time_between_shots = 0.0
	animation_player.play("Idle")
	reloading = false
	
