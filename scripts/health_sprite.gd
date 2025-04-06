extends TextureRect

@export var player : Player

@export var first_x : float = 1400.0
@export var second_x : float = 1400.0
@export var third_x : float = 1400.0
@export var fourth_x : float = 1400.0
@export var fifth_x : float = 1400.0

var atlas

func _ready() -> void:
	player.health_changed.connect(change_state)

func change_state():
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
	var _rect = texture.region
