extends Control

var gui
var music_volume
var sfx_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	music_volume = $musicVolume
	sfx_volume = $sfXVolume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_music_volume_value_changed(value):
	BankManager.set_music_volume(value)


func _on_sf_x_volume_value_changed(value):
	BankManager.set_sfx_volume(value)


func _on_continue_button_pressed():
	gui.i = 0
	gui.flag = false
	get_tree().paused = false
	self.position.y = -220

func _on_restart_button_pressed():
	pass # Replace with function body.


func _on_exit_button_pressed():
	pass # Replace with function body.
