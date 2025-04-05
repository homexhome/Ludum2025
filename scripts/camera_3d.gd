extends Camera3D

var mouse_sensitivity = 0.3
var pitch_limit = 30.0

var active : bool = false

func _ready() -> void:
	set_active_status(true)
	
func _input(event):
	if event is InputEventMouseMotion:
		if active:
			var delta = event.relative * mouse_sensitivity
			rotation_degrees.y -= delta.x
			rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
			
			rotation_degrees.x -= delta.y
			rotation_degrees.x = clampf(rotation_degrees.x, -90, 70)
			
	if event.is_action_pressed("esc"):
		set_active_status(!active)
			
func set_active_status(status : bool):
	active = status
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
