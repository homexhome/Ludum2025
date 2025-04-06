extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerGroup"):
		$Area3D.queue_free()
		Session.add_gold()
		$AudioStreamPlayer3D.play()
		hide()
		await $AudioStreamPlayer3D.finished
		queue_free()
