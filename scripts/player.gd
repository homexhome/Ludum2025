class_name Player
extends CharacterBody3D

var current_weapon : Weapon

func _ready() -> void:
	Session.set_player(self)
