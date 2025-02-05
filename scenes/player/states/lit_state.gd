class_name LitState
extends PlayerState

var direction: float
var run_velocity_change_rate: float = 5.0 

func enter() -> void:
	context.explode_timer.timeout.connect(_on_explosion_timer_timeout)
	direction = context.input_component.input_horizontal
	if direction == 0:
		direction = sign(context.velocity.x) if context.velocity.x != 0 else 1
	context.sprite_animation.start_lit_timer(context.explode_timer.wait_time)	# use different timer as set by the level
	context.explode_timer.start()
	SoundManager.start_lit_music_background(context.explode_timer.get_wait_time())
	
static func new_state(ctx: Player) -> PlayerState:
	var new_state = new()
	new_state.context = ctx	
	return new_state

func process(delta: float) -> void:
	if context.is_on_wall():
		direction *= -1.0
		context.velocity.x = 0
	context.velocity.x = move_toward(context.velocity.x, direction * context.run_speed, run_velocity_change_rate)
	context.jump_component.handle_jump(context, context.input_component.get_jump_input(), context.input_component.get_jump_released(), context.jump_velocity)
	context.sprite_animation.handle_run_animation(direction)

## Play explode animation and emit exploded signal once it finished.
##
## This funciton helps to time the respawn animaiton only after the explosion ended.
## It is invoked in two cases:
##   1. whenever the explode_timer.timeout signal is emitted
##   2. whenever the player enters the death-zone
##
## Due to the second case, the guard check to stop the timer is required to prevent
## executing the animation twice (when entering the death-zone and when the previously started
## timer terminates).	
func _on_explosion_timer_timeout() -> void:
	if (!context.explode_timer.is_stopped()):
		context.explode_timer.stop()
		# if the explosion was triggered by the death-zone, stop lit music
		SoundManager.stop_lit_music_background()
	context.explode_timer.timeout.disconnect(_on_explosion_timer_timeout)
	context.change_state(ExplodeState.new_state(context))
