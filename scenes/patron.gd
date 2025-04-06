extends MeshInstance3D


func _ready() -> void:
	rotation_degrees.y = randf_range(0,360)
