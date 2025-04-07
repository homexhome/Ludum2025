extends Camera3D

var mouse_sensitivity = 0.3
var pitch_limit = 30.0

var active : bool = false
var set_status : bool = false

func _ready() -> void:
	set_active_status(true)
	
#func _unhandled_input(_event: InputEvent) -> void:
	#if set_status == false:
		#set_active_status(true)
		#set_status = true

func _input(event):
	if Session.get_if_paused(): return
	
	if event is InputEventMouseMotion :
		if active:
			var delta = event.relative * mouse_sensitivity
			rotation_degrees.y -= delta.x
			rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
			
			rotation_degrees.x -= delta.y
			rotation_degrees.x = clampf(rotation_degrees.x, -90, 70)
			
func set_active_status(status : bool):
	active = status
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Session.end_pause.emit()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Session.end_pause.emit()
		
