extends Node

@onready var fuse_sound = $Fuse2

func play():
	fuse_sound.set_volume_db(-10.0)
	fuse_sound.play()
	
func stop():
	fuse_sound.stop()
