class_name Goal
extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $GoalArea/GoalCollision
	
func _on_explosion_hit_goal() -> void:
	sprite.play("destroy")
	collision.disabled = true	# prevent playing animation multiple time
