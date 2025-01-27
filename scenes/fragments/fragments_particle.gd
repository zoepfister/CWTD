## Emits debris and register timer to remove itself from the tree.
##
## The particles executes one (oneshot) and spawn four randomly selected debris
## that are thrown at once (explosiveness = 1.0) with variable speed from the
## global_position of the node.
class_name FragmentsParticle
extends CPUParticles2D

func _ready() -> void:
	emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()
