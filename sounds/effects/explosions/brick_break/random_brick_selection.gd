extends Node

@onready var audio_stream_player = $AudioStreamPlayer

@onready var brick_break_sound_list = [
	preload("res://sounds/effects/explosions/brick_break/brick_break1.wav"),
	preload("res://sounds/effects/explosions/brick_break/brick_break2.wav"),
	preload("res://sounds/effects/explosions/brick_break/brick_break3.wav"),
]

func play(from_position = 0.0) -> void:
	audio_stream_player.stream = brick_break_sound_list.pick_random()
	audio_stream_player.play(from_position)
