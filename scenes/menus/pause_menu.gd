extends Control

@onready var tinamy: PlayerSprite = $PlayerSprite
@onready var tinamy_shadow: PlayerSprite = $PlayerFakeShadow
@onready var sound_manager = $SoundManager

#@export var start_scene = "res://scenes/Game.tscn"
#
#func _ready() -> void:
	#tinamy.play_animation("run")
	#tinamy_shadow.play_animation("run")
	##sound_manager.start_background_music()

func _ready() -> void:
	$"../../Player/Components/InputComponent".connect("check_escape", _on_pause_pressed)
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
	sound_manager.stop_background_music()
	get_tree().reload_current_scene()
