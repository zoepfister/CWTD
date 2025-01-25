extends VSlider

@export var audio_bus_name = "Master"

@onready var _bus = AudioServer.get_bus_index(audio_bus_name)
@onready var sound_manager =  $"../SoundManager"

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))
	
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))

func _on_drag_ended(value_changed: bool) -> void:
	if audio_bus_name == "Effects":
		sound_manager.play_explosion_sound()
