extends Node3D

var _mesh : MeshInstance3D

func _ready() -> void:
	_mesh = $Visuals.get_children().pick_random()
	for ms in $Visuals.get_children():
		if _mesh != ms:
			ms.queue_free()
	_mesh.visible = true

func _physics_process(delta: float) -> void:
	#if Session.get_depth_perceprion() != visibility_range_end:
	_mesh.set_visibility_range_end(snappedf(Session.get_depth_perceprion(),0.1))
	
