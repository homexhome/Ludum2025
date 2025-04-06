extends TextureRect

@export var player : Player

@export var first_x : float = 1400.0
@export var second_x : float = 1400.0
@export var third_x : float = 1400.0
@export var fourth_x : float = 1400.0
@export var fifth_x : float = 1400.0

var atlas

var time_from_show : float = 0.0

func _ready() -> void:
	player.health_changed.connect(change_state)

func _physics_process(delta: float) -> void:
	if time_from_show > 0.0:
		time_from_show -= delta
		if time_from_show <= 0:
			hide()

func change_state():
	show()
	time_from_show = 5.0
	var rect = texture.region
	match player.health:
		5:
			rect.position.x = fifth_x
		4:
			rect.position.x = fourth_x
		3:
			rect.position.x = third_x
		2:
			rect.position.x = second_x
		1:
			rect.position.x = first_x
	texture.set_region(rect)
	$AnimationPlayer.play("new_animation")
	var _rect = texture.region
	
