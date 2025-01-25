

class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

func _handle_horizontal_flip(direction: float) -> void:
	if direction == 0:
		return
	
	sprite.flip_h = false if direction > 0 else true
	
func handle_move_animation(move_direciton: float, animation_name: String) -> void :
	_handle_horizontal_flip(move_direciton)
	play_animation(animation_name)

func play_animation(animation_name:String) -> void:
	sprite.play(animation_name)

func set_animation(animation_name: String) -> void:
	sprite.animation = animation_name
