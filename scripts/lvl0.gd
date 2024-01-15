extends Node

var player

func _ready():
	player = find_child("Player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
