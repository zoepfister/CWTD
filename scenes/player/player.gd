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

signal exploded(explosion_area: Area2D, radius: float)
signal ready_to_respawn
var current_state: PlayerState = PlayerIdleState.new_state(self)
var explosion_radius: float

func _ready() -> void:
	camera.make_current()
	sprite_animation.play_animation("idle")
	explosion_radius = (explosion_shape.shape as CircleShape2D).radius
	SoundManager.start_background_music()

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	current_state.process(delta)
	move_and_slide()

## Context method
func change_state(state: PlayerState) -> void:
	current_state.exit()
	current_state = state
	state.enter()
			
func on_repsawn():
	change_state(PlayerIdleState.new_state(self))
	gravity_component.enable_gravity()
	visible = true

func _on_jump_sucess_signal() -> void:
	SoundManager.play_jump_sound()
	
func can_be_lit() -> bool:
	return current_state is PlayerIdleState || current_state is MoveState
