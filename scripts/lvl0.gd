extends Node

var player
var enemy

func _ready():
	player = find_child("Player")
	enemy = find_child("Butterboy")
	enemy.player = player
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
