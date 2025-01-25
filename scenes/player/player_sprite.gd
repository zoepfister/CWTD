class_name PlayerSprite
extends Node2D

@export_subgroup("Nodes")
@export var body: AnimationComponent
@export var fuse: AnimationComponent
@export var legs: AnimationComponent
@export var lit_timer: Timer

var on_explosion_finished: Callable = Callable(self, "_on_explosion_finished")
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
	
func start_lit_timer() -> void:
	lit_timer.start()
	
func handle_explode_animation() -> void:
	fuse.set_animation("explode")
	legs.set_animation("explode")
	body.play_animation("explode")
	body.sprite.animation_finished.connect(on_explosion_finished)
	
func _on_explosion_finished() -> void:
	fuse_lit_animation = "lit_0%"
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
