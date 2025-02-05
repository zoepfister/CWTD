class_name DeathZone
extends Area2D

## DeathZone only looks for the player.
## As soon as the player entered the death-zone, make the player explode
func _on_body_entered(body: Node2D) -> void:
	(body as Player).change_state(ExplodeState.new_state(body as Player))
