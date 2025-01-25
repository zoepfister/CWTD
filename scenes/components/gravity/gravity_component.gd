class_name GravityComponent
extends Node

@export_subgroup("Settings")
@export var gravity: float = 1000.0

var is_falling: bool = false
var is_gravity_enabled: bool = true

func handle_gravity(body: CharacterBody2D, delta:float):
	if is_gravity_enabled and not body.is_on_floor():
		body.velocity.y += gravity * delta
	is_falling = body.velocity.y > 0 and not body.is_on_floor()
	
func handle_gravity_physics_body(body: RigidBody2D, delta:float):
	body.linear_velocity.y += gravity * delta

func enable_garvity() -> void:
	is_gravity_enabled = true
	
func disable_garvity() -> void:
	is_gravity_enabled = false
