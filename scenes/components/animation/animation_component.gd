class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

func handle_horizontal_flip(direction: float) -> void:
	if direction == 0:
		return
	
	sprite.flip_h = false if direction > 0 else true
	
func handle_move_animation(move_direciton: float) -> void :
	handle_horizontal_flip(move_direciton)
	if move_direciton != 0:
		sprite.play("move")
	else:
		sprite.play("idle")
