class_name PlayerIdleState
extends PlayerState

func enter() -> void:
	context.sprite_animation.set_idle_animation()

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
	context.jump_component.handle_jump(context, context.input_component.get_jump_input(), context.input_component.get_jump_released(), context.jump_velocity)
	if context.input_component.input_horizontal != 0:
		context.change_state(MoveState.new_state(context))
