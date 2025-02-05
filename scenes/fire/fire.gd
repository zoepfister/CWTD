extends Area2D

@onready var sprite: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D

func _ready() -> void:
	sprite.play("default")

func _on_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player.can_be_lit():
		player.change_state(LitState.new_state(player))
