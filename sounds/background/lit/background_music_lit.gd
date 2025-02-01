extends Node

# This script is used to control the background music for the lit up Tinamy
# When play() is called, the background music will play for the duration of the duration_seconds variable in a loop
# All different backing click-tracks will be played simultaneously, however, the volume of each track will be (un)muted 
# based on the percentage of the duration_seconds that the respective click-track should be played for

@export var percentage_slow_speed: float = .5;
@export var percentage_fast_speed: float = .3;
@export var percentage_fastest_speed: float = .2;

#	Must be auto-looping (WAV File)
@onready var background_audio_player: AudioStreamPlayer = $Background_Music_Lit
@onready var click_slow_player: AudioStreamPlayer = $lit_click_slow
@onready var click_faster_player: AudioStreamPlayer = $lit_click_faster
@onready var click_fastest_player: AudioStreamPlayer = $lit_click_fastest
@onready var fuse_sound = $Fuse

var timer_faster: Timer
var timer_fastest: Timer
var timer_end: Timer

@export var original_background_track: AudioStreamPlayer

func _init() -> void:
	if percentage_slow_speed + percentage_fast_speed + percentage_fastest_speed != 1.0:
		push_error("Background music percentages for lit up Tinamy do not equal 100.")

func setup_audio_players():
	unmute_player(click_slow_player)
	mute_player(click_faster_player)
	mute_player(click_fastest_player)

func _ready() -> void:
	setup_audio_players()

# Mute the audio stream (volume to -80 dB)
func mute_player(player: AudioStreamPlayer):
	player.volume_db = -80
	
# Unmute the audio stream (volume to -5 dB)
func unmute_player(player: AudioStreamPlayer):
	player.volume_db = -5

func _on_timer_faster_timeout() -> void:
	mute_player(click_slow_player)
	unmute_player(click_faster_player)
	
func _on_timer_fastest_timeout() -> void:
	mute_player(click_faster_player)
	unmute_player(click_fastest_player)
	
func stop_all_players():
	background_audio_player.stop()
	click_slow_player.stop()
	click_faster_player.stop()
	click_fastest_player.stop()
	fuse_sound.stop()
	timer_end.stop()
	timer_faster.stop()
	timer_fastest.stop()

func play_all_players():
	background_audio_player.play()
	click_slow_player.play()
	click_faster_player.play()
	click_fastest_player.play()
	fuse_sound.play()

# TODO: Move explosion to its own scene
func _on_timer_end_timeout() -> void:
	stop_all_players()
	#explosion_sound_effect.play()

# Creates a timer with one_shot set to true, and autostart set to false
# @param wait_time: The time in seconds to wait before the timer times out
# @param timeout_connector: The function to call when the timer times out
# @return Timer: The timer object
func create_timer(wait_time: float, timeout_connector: Callable) -> Timer:
	var timer: Timer = Timer.new();
	timer.one_shot = true  # Set to false for repeating timer
	timer.autostart = false
	timer.wait_time = wait_time
	timer.connect("timeout", timeout_connector)
	return timer;


func play(duration_seconds: float = 5) -> void:
	setup_audio_players()
	timer_faster = create_timer(duration_seconds * percentage_slow_speed, _on_timer_faster_timeout)
	add_child(timer_faster)
	timer_fastest = create_timer(duration_seconds * (percentage_slow_speed + percentage_fast_speed), _on_timer_fastest_timeout)
	add_child(timer_fastest)
	
	timer_end = create_timer(duration_seconds, _on_timer_end_timeout)
	add_child(timer_end)
	
	play_all_players()
	
	timer_end.start()
	timer_faster.start()
	timer_fastest.start()
