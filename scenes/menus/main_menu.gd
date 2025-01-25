extends Control

@onready var tinamy: PlayerSprite = $PlayerSprite
@onready var tinamy_shadow: PlayerSprite = $PlayerFakeShadow
@onready var sound_manager = $SoundManager

@export var start_scene = "res://scenes/Game.tscn"

func _ready() -> void:
	tinamy.play_animation("run")
	tinamy_shadow.play_animation("run")
	sound_manager.start_background_music()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(start_scene)


func _on_exit_pressed() -> void:
	get_tree().quit()
