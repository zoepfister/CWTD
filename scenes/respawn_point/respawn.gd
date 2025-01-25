class_name Respawn
extends AnimatedSprite2D

@onready var player: Player = get_tree().get_first_node_in_group("player")

signal respawn_animation_finished

var animaiton_finished: Callable = Callable(self, "_on_animation_finished") 

func _ready() -> void:
	animation_finished.connect(animaiton_finished)
	
func play_respawn_animation() -> void:
	play("respawn")

func _on_animation_finished() -> void:
	respawn_animation_finished.emit()
	animation = "default"
