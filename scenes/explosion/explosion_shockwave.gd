class_name Shockwave
extends Node2D

@onready var animation: AnimationPlayer = $CanvasLayer/AnimationPlayer

func play_shockwave() -> void:
	animation.play("shockwave")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
