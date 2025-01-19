extends CharacterBody2D

@export_subgroup("Nodes")
@export var camera: Camera2D
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: VariableHeightJumpComponent
@export var animation_component: AnimationComponent

func _ready() -> void:
	camera.make_current()

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	animation_component.handle_move_animation(input_component.input_horizontal)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_released())
	move_and_slide()
