class_name DeadState
extends PlayerState

func enter() -> void:
	context.visible = false		# wait until explosion animation ended
	SoundManager.start_background_music()
	context.ready_to_respawn.emit()

static func new_state(ctx: Player) -> PlayerState:
	var new_state = new()
	new_state.context = ctx
	return new_state
