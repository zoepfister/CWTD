class_name Fragment
extends Node2D

@export_subgroup("Settings")
@export var lifetime: float = 4.0
@export var fragment_speed: float = 500.0

@onready var fragment_1: RigidBody2D = $Fragment
@onready var fragment_2: RigidBody2D = $Fragment2
@onready var fragment_3: RigidBody2D = $Fragment3
@onready var fragment_4: RigidBody2D = $Fragment4

func _ready() -> void:
	set_initial_speed()
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
func set_initial_speed() -> void:
	fragment_1.linear_velocity = Vector2(-0.3, -1).normalized() * fragment_speed
	fragment_2.linear_velocity = Vector2(0.3, -1).normalized() * fragment_speed
	fragment_3.linear_velocity = Vector2(-1, -1).normalized() * fragment_speed
	fragment_4.linear_velocity = Vector2(1, -1).normalized() * fragment_speed
