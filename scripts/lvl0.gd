extends Node

var player
var enemy

func _ready():
	player = find_child("Player")
	enemy = find_child("Butterboy")
	enemy.player = player
