class_name Player
extends CharacterBody2D

@export_subgroup("Settings")
@export var movement_speed: float = 100.0
@export var run_speed: float = 250.0
@export var jump_velocity: float = -350.0
var run_velocity_change_rate: float = 5.0 
var direction: float = 1.0

@export_subgroup("Nodes")
@export var camera: Camera2D
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: VariableHeightJumpComponent
@export var sprite_animation: PlayerSprite

@onready var explode_timer: Timer = $ExplodeTimer
@onready var explosion_area: Area2D = $ExplosionArea
@onready var explosion_shape: CollisionShape2D = $ExplosionArea/ExplosionCollisionShape
@onready var fragment_scene: PackedScene = preload("res://scenes/fragments/fragment_scene.tscn")
var explosion_radius: float

signal exploded(explosion_area: Area2D, radius: float)
signal ready_to_respawn

enum States { IDLE, LIT, MOVING, DEAD}
var state: States = States.IDLE

func _ready() -> void:
	camera.make_current()
	sprite_animation.play_animation("idle")
	explosion_radius = (explosion_shape.shape as CircleShape2D).radius
	sprite_animation.explosion_finished.connect(_on_explosion_animation_finished)
	SoundManager.start_background_music()

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	if state == States.MOVING:
		_handle_moving_state()
	elif state == States.LIT:
		_handle_lit_state()
	elif state == States.IDLE:
		_handle_idle()
	move_and_slide()

func _handle_idle():
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal, movement_speed)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_released(), jump_velocity)
	if input_component.input_horizontal != 0:
		set_state(States.MOVING)

func _handle_moving_state():
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal, movement_speed)
	sprite_animation.handle_move_animation(input_component.input_horizontal)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_released(), jump_velocity)
	if input_component.input_horizontal == 0 and is_on_floor():
		set_state(States.IDLE)
	
func _handle_lit_state():
	if is_on_wall():
		direction *= -1.0
		velocity.x = 0
	velocity.x = move_toward(velocity.x, direction * run_speed, run_velocity_change_rate)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_released(), jump_velocity)
	sprite_animation.handle_run_animation(direction)

func set_state(new_state: States) -> void:
	# Prevent unwanted interactions when dead
	if state == States.DEAD and new_state != States.IDLE:
		return
	var old_state: States = state
	state = new_state
	if old_state == state:
		return	
	if state == States.LIT:
		direction = input_component.input_horizontal
		if direction == 0:
			direction = sign(velocity.x) if velocity.x != 0 else 1
		sprite_animation.start_lit_timer()
		explode_timer.start()
		SoundManager.start_lit_music_background(explode_timer.get_wait_time())
		# start music
	elif state == States.IDLE:
		sprite_animation.set_idle_animation()
	elif state == States.DEAD:
		# explosion sound (check timing)
		SoundManager.play_explosion_sound()
	
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
func explode() -> void:
	if (!explode_timer.is_stopped()):
		explode_timer.stop()
		# if the explosion was triggered by the death-zone, stop lit music
		SoundManager.stop_lit_music_background()
	set_state(States.DEAD)
	velocity = Vector2(0.0,0.0)
	gravity_component.disable_gravity()		# prevent camera to follow falling through holes
	sprite_animation.handle_explode_animation(global_position)
	exploded.emit(explosion_area, explosion_radius)

func _on_explode_timer_timeout() -> void:
	explode()
			
func _on_explosion_animation_finished() -> void:
	visible = false		# wait until explosion animation ended
	SoundManager.start_background_music()
	ready_to_respawn.emit()
			
func on_repsawn():
	set_state(States.IDLE)
	gravity_component.enable_gravity()
	visible = true

func _on_jump_sucess_signal() -> void:
	SoundManager.play_jump_sound()
