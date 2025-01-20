class_name InputComponent
extends Node

var input_horizontal: float = 0.0

func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("move_left","move_right")		# input_horizontal will be -1 when we move left,
																	# 1 when move right, and 0 when we don't move
	
func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")
	
func get_jump_released() -> bool:
	return Input.is_action_just_released("jump")
