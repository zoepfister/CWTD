class_name InputComponent
extends Node

var input_horizontal: float = 0.0

signal check_escape

func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("move_left","move_right")		# input_horizontal will be -1 when we move left,
																	# 1 when move right, and 0 when we don't move
	get_escape_input()

func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")
	
func get_jump_released() -> bool:
	return Input.is_action_just_released("jump")

func get_escape_input() -> bool:
	var escape_pressed = Input.is_action_just_pressed("escape")
	if escape_pressed:
		check_escape.emit()
	return escape_pressed
