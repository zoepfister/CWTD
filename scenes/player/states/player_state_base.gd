class_name PlayerState
extends Node

var context: Player

func enter() -> void:
	pass
	
func exit() -> void:
	queue_free()
	
func process(delta: float) -> void:
	pass
	
static func new_state(ctx: Player) -> PlayerState:
	assert(false, "This method must be overridden in a subclass")
	return null
	
func _unimplemented() -> void:
	assert(false, "This method must be overridden in a subclass")
