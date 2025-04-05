extends MeshInstance3D

#func _ready() -> void:
	#var frame_to_skip : int = randi_range(1,6)
	#var _frame_to_skip : int = frame_to_skip
	#while true:
		#if frame_to_skip > 0:
			#frame_to_skip -= 1
			#await get_tree().process_frame
		#else:
			#frame_to_skip = _frame_to_skip
			#update_depth_perceprion()

func _physics_process(delta: float) -> void:
	#if Session.get_depth_perceprion() != visibility_range_end:
	set_visibility_range_end(Session.get_depth_perceprion())
	
