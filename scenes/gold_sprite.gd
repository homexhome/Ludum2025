extends TextureRect

@export var player : Player

var atlas
var time_from_show : float = 0.0

func _ready() -> void:
	Session.gold_added.connect(change_state)

func _physics_process(delta: float) -> void:
	if time_from_show > 0.0:
		time_from_show -= delta
		if time_from_show <= 0:
			hide()

func change_state():
	show()
	$AnimationPlayer.play("new_animation_2")
	time_from_show = 2
	
