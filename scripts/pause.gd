extends ColorRect

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		set_pause_status()

func go_to_menu():
	get_tree().call_deferred("change_scene_to_file","res://scenes/main_menu.tscn")

func set_pause_status():
	var status = !visible
	get_tree().paused = status
	visible = status
	if !status:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
