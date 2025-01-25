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
@export var animation_component: AnimationComponent

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
	animation_component.set_animation("idle")
	explosion_radius = (explosion_shape.shape as CircleShape2D).radius

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	if state == States.MOVING:
		_handle_moving_state()
	elif state == States.LIT:
		_handle_lit_state()
	elif state == States.IDLE:
		_handle_idle()
	move_and_slide()
	
############################
#     States' handlers     #
############################

func _handle_idle():
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal, movement_speed)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_released(), jump_velocity)
	if input_component.input_horizontal != 0:
		set_state(States.MOVING)

func _handle_moving_state():
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal, movement_speed)
	animation_component.handle_move_animation(input_component.input_horizontal, "move")
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_released(), jump_velocity)
	if input_component.input_horizontal == 0 and is_on_floor():
		set_state(States.IDLE)
	
func _handle_lit_state():
	if is_on_wall():
		direction *= -1.0
		velocity.x = 0
	velocity.x = move_toward(velocity.x, direction * run_speed, run_velocity_change_rate)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_released(), jump_velocity)
	animation_component.handle_move_animation(direction, "run")
	
func set_state(new_state: States) -> void:
	var old_state: States = state
	state = new_state
	if old_state == state:
		return	
	if state == States.LIT:
		direction = input_component.input_horizontal
		if direction == 0:
			direction = sign(velocity.x) if velocity.x != 0 else 1
		explode_timer.start()
	elif state == States.IDLE:
		animation_component.set_animation("idle")

#######################################
#              Signals                #
#######################################

func _on_explode_timer_timeout() -> void:
	set_state(States.DEAD)
	velocity = Vector2(0.0,0.0)
	gravity_component.disable_garvity()		# prevent camera to follow falling through holes
	animation_component.set_animation("explode")
	animation_component.sprite.animation_finished.connect(Callable(self, "_on_explosion_animation_finished"))
	exploded.emit(explosion_area, explosion_radius)
			
func _on_explosion_animation_finished() -> void:
	visible = false		# wait until explosion animation ended
	ready_to_respawn.emit()
			
func on_repsawn():
	set_state(States.IDLE)
	gravity_component.enable_garvity()
	visible = true
	
