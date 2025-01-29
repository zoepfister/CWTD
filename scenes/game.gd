extends Node2D

@onready var current_level: Node2D = $Level

func change_level(next_level: Level):
	current_level.queue_free()
	add_child(next_level)
	current_level = next_level
