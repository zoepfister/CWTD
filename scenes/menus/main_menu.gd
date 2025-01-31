extends Control

@onready var tinamy: PlayerSprite = $CanvasLayer/PlayerSprite
@onready var tinamy_shadow: PlayerSprite = $CanvasLayer/PlayerFakeShadow

@export var start_scene = "res://scenes/Game.tscn"

func _ready() -> void:
	tinamy.play_animation("run")
	tinamy_shadow.play_animation("run")
	SoundManager.start_background_music()

func _on_pause_pressed() -> void:
	get_tree().paused = true
	show()
	
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(start_scene)

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false
