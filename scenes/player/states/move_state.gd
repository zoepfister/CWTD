class_name MoveState
extends PlayerState

static func new_state(ctx: Player) -> PlayerState:
	var new_state = new()
	new_state.context = ctx
	return new_state
	
func _on_explosion_animation_finished() -> void:
	context.visible = false		# wait until explosion animation ended
	SoundManager.start_background_music()
	context.ready_to_respawn.emit()
	context.sprite_animation.explosion_finished.disconnect(_on_explosion_animation_finished)

func process(delta: float) -> void:
	context.movement_component.handle_horizontal_movement(context, context.input_component.input_horizontal, context.movement_speed)
	context.sprite_animation.handle_move_animation(context.input_component.input_horizontal)
	context.jump_component.handle_jump(context, context.input_component.get_jump_input(), context.input_component.get_jump_released(), context.jump_velocity)
	if context.input_component.input_horizontal == 0 and context.is_on_floor():
		context.change_state(PlayerIdleState.new_state(context))
