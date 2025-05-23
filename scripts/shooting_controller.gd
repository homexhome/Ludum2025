extends Node3D

@export var camera : Camera3D
@onready var player : Player = get_parent()

func _process(_delta: float) -> void:
	if Session.get_if_paused(): return
	if player.current_weapon == null: return
	
	if player.current_weapon._time_between_shots == 0.0 and Input.is_action_pressed("attack") and player.current_weapon.reloading == false:
		player.current_weapon.attack()
		if player.current_weapon.reloading: return
		
		player.spawn_ammo_single()
		var query = PhysicsRayQueryParameters3D.create(camera.global_position, camera.global_position - camera.global_transform.basis.z * 10000 ,3,[player.get_rid()])
		query.collide_with_areas = true
		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(query)
		if result.has("position"):
			var collider = result["collider"]
			if collider.has_method("take_damage"):
				collider.take_damage(player.current_weapon.weapon_resource.damage, result["position"])
	elif Input.is_action_pressed("reload"):
		player.current_weapon.reload()
