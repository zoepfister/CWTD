extends Area2D

@onready var sprite: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D

func _ready() -> void:
	sprite.play("default")

func _on_body_entered(body: Node2D) -> void:
	(body as Player).set_state(Player.States.LIT)
