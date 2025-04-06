class_name Enemy
extends CharacterBody3D
@export var entity_resource : EntityResource


enum STATE {ACTIVE, NOT_ACTIVE}
var enemy_state : STATE = STATE.NOT_ACTIVE
