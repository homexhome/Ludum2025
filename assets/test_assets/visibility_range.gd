extends MeshInstance3D

#func _ready() -> void:
	#var mat : BaseMaterial3D = mesh.get_material()
#

func _physics_process(delta: float) -> void:
	#if Session.get_depth_perceprion() != visibility_range_end:
	set_visibility_range_end(Session.get_depth_perceprion())
	
