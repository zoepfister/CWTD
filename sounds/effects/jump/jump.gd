extends Node

@onready var audio_stream_player = $AudioStreamPlayer

@onready var jump_list = [
	preload("res://sounds/effects/jump/jump1.wav"),
	preload("res://sounds/effects/jump/jump2.wav"),
	preload("res://sounds/effects/jump/jump3.wav"),
]

func play(from_position = 0.0) -> void:
	audio_stream_player.stream = jump_list.pick_random()
	audio_stream_player.play(from_position)
