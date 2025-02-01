extends Level

@onready var camera: Camera2D = get_tree().get_first_node_in_group("PlayerCamera")

func _ready():
	super._ready()
	_do_cam_positioning()

func _respawn_player():
	super._respawn_player()
	_do_cam_positioning()
	
func _do_cam_positioning():
	camera.drag_horizontal_offset = 1.0
	camera.drag_vertical_offset = -0.67
	camera.drag_left_margin = 0.43
	camera.drag_bottom_margin = 0.41
