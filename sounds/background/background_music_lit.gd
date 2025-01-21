extends Node

@export var duration_seconds: int = 5

@export var percentage_slow_speed: float = .5;
@export var percentage_fast_speed: float = .3;
@export var percentage_fastest_speed: float = .2;

#	Must be auto-looping (WAV File)
@onready var background_audio_player: AudioStreamPlayer = $Background_Music_Lit
@onready var click_slow_player: AudioStreamPlayer = $lit_click_slow
@onready var click_faster_player: AudioStreamPlayer = $lit_click_faster
@onready var click_fastest_player: AudioStreamPlayer = $lit_click_fastest


func _init() -> void:
	if percentage_slow_speed + percentage_fast_speed + percentage_fastest_speed != 1.0:
		push_error("Background music percentages for lit up Tinamy do not equal 100.")

func _ready() -> void:
	click_faster_player.volume_db = -80;
	click_fastest_player.volume_db = -80;
#	For debug only
	play();


func _on_timer_faster_timeout() -> void:
	click_slow_player.volume_db = -80;
	click_faster_player.volume_db = -5;
	
	
func _on_timer_fastest_timeout() -> void:
	click_faster_player.volume_db = -80;
	click_fastest_player.volume_db = -5;
	
func _on_timer_end_timeout() -> void:
	background_audio_player.stop()
	click_slow_player.stop()
	click_faster_player.stop()
	click_fastest_player.stop()

func play() -> void:
	var timer_faster: Timer = Timer.new();
	timer_faster.one_shot = true  # Set to false for repeating timer
	timer_faster.autostart = false
	timer_faster.wait_time = duration_seconds * percentage_slow_speed
	add_child(timer_faster)
	var timer_fastest: Timer = Timer.new();
	add_child(timer_fastest)
	background_audio_player.play()
	click_slow_player.play()
	click_faster_player.play()
	click_fastest_player.play()
	
	var timer_end: Timer = Timer.new();
	timer_end.one_shot = true  # Set to false for repeating timer
	timer_end.autostart = false
	timer_end.wait_time = duration_seconds;
	add_child(timer_end)
	timer_end.connect("timeout", _on_timer_end_timeout);
	timer_end.start()
	
	timer_faster.connect("timeout", _on_timer_faster_timeout);
	timer_faster.start()
	timer_fastest.connect("timeout", _on_timer_fastest_timeout);
	timer_fastest.start(duration_seconds * (percentage_slow_speed + percentage_fast_speed))
	


func set_duration(seconds: int):
	duration_seconds = seconds;
