extends Node

@onready var audio_stream_player = $AudioStreamPlayer

@onready var explosion_list = [
	preload("res://sounds/effects/explosions/explosion1.wav"),
	preload("res://sounds/effects/explosions/explosion2.wav"),
	preload("res://sounds/effects/explosions/explosion3.wav"),
	preload("res://sounds/effects/explosions/explosion4.wav"),
]

func play(from_position = 0.0) -> void:
	audio_stream_player.stream = explosion_list.pick_random()
	audio_stream_player.play(from_position)
