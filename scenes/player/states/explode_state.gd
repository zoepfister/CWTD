class_name ExplodeState
extends PlayerState

func enter() -> void:
	context.velocity = Vector2(0.0,0.0)
	context.gravity_component.disable_gravity()		# prevent camera to follow falling through holes
	context.sprite_animation.handle_explode_animation(context.global_position)
	context.exploded.emit(context.explosion_area, context.explosion_radius)
	context.sprite_animation.explosion_finished.connect(_on_explosion_animation_finished)
	SoundManager.play_explosion_sound()
	
static func new_state(ctx: Player) -> PlayerState:
	var new_state = new()
	new_state.context = ctx	
	return new_state
	
func _on_explosion_animation_finished() -> void:
	context.change_state(DeadState.new_state(context))
	context.sprite_animation.explosion_finished.disconnect(_on_explosion_animation_finished)
