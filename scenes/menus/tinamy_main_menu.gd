extends Node

@onready var legs = $Legs
@onready var body = $Body
@onready var fuse = $Fuse

func play() -> void:
	legs.play()
	body.play()
	fuse.play()
