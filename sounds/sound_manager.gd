extends Node

@onready var background_music: AudioStreamPlayer = $Background_music
@onready var explosion_sound_effect = $Explosion_sound_effect
@onready var lit_background_music = $Lit_background_music
@onready var jump_effect = $Jump

func start_background_music():
	background_music.play()
	
func stop_background_music():
	background_music.stop()

func play_explosion_sound():
	explosion_sound_effect.play()
	
func start_lit_music_background(duration_seconds: float = 5):
	#	Stop playing the normal background music first.
	background_music.stop()
	lit_background_music.play(duration_seconds)
	
func stop_lit_music_background():
	lit_background_music.stop()

func jump():
	jump_effect.play()

func _on_player_play_jump_sound() -> void:
	jump()
