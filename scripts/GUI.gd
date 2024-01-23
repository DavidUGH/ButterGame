extends Control


var life_label : Label
var console_label: Label
var pause_menu:Control

# Called when the node enters the scene tree for the first time.
func _ready():
	life_label = $LifeLabel
	console_label = $ConsoleLabel
	pause_menu = $OptionsMenu

func set_life(life):
	life_label.text = "Life: " + str(life)+"%"

func setConsole(msg):
	console_label.text = msg


func _on_texture_button_pressed():
	get_tree().paused = true
	pause_menu.position.y = 50
