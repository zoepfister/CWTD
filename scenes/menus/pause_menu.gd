extends Control

@export_subgroup("Nodes")
@export var tinamy: PlayerSprite
@export var tinamy_shadow: PlayerSprite

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	player.input_component.connect("check_escape", _on_pause_pressed)
	tinamy.play_animation("idle")
	tinamy_shadow.play_animation("idle")

func _on_pause_pressed() -> void:
	get_tree().paused = true
	show()

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_restart_pressed() -> void:
	_on_resume_pressed()
	SoundManager.stop_background_music()
	get_tree().reload_current_scene()
