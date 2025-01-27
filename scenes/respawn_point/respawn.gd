class_name Respawn
extends AnimatedSprite2D

signal respawn_animation_finished

func _ready() -> void:
	animation_finished.connect(_on_animation_finished)
	
func play_respawn_animation() -> void:
	play("respawn")

func _on_animation_finished() -> void:
	respawn_animation_finished.emit()
	animation = "default"
