class_name PlayerSprite
extends Node2D

@export_subgroup("Nodes")
@export var body: AnimationComponent
@export var fuse: AnimationComponent
@export var legs: AnimationComponent
@export var lit_timer: Timer

@onready var shockwave_scene: PackedScene = preload("res://scenes/explosion/explosion_shockwave.tscn")

var fuse_lit_animation = "lit_0%"

signal explosion_finished

func set_idle_animation() -> void:
	body.play_animation("idle")
	fuse.play_animation("idle")
	legs.play_animation("idle")
	
func handle_move_animation(direction: float) -> void:
	body.handle_move_animation(direction, "move")
	fuse.handle_move_animation(direction, "move")
	legs.handle_move_animation(direction, "move")
	
func handle_run_animation(direction: float) -> void:
	body.handle_move_animation(direction, "run")
	fuse.handle_move_animation(direction, fuse_lit_animation)
	legs.handle_move_animation(direction, "run")
	
func start_lit_timer(duration: float = 5.0) -> void:
	lit_timer.wait_time = duration / 4.0	# Chnage lit fuse sprites evenly until player explodes
	lit_timer.start()
	
func handle_explode_animation(explosion_position: Vector2) -> void:
	fuse.set_animation("explode")
	legs.set_animation("explode")
	body.play_animation("explode")
	var shockwave: Shockwave = shockwave_scene.instantiate()
	add_child(shockwave)
	shockwave.global_position = explosion_position
	shockwave.play_shockwave()
	body.sprite.animation_finished.connect(_on_explosion_finished)
	
func _on_explosion_finished() -> void:
	fuse_lit_animation = "lit_0%"
	body.sprite.animation_finished.disconnect(_on_explosion_finished)
	explosion_finished.emit()
	
func play_animation(animation_name: String) -> void:
	body.play_animation(animation_name)
	fuse.play_animation(animation_name)
	legs.play_animation(animation_name)

func _on_fuse_lit_timer_timeout() -> void:
	if(fuse_lit_animation == "lit_0%"):
		fuse_lit_animation = "lit_25%"
		lit_timer.start()
	elif(fuse_lit_animation == "lit_25%"):
		fuse_lit_animation = "lit_50%"
		lit_timer.start()
	elif(fuse_lit_animation == "lit_50%"):
		fuse_lit_animation = "lit_75%"
