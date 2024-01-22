extends Control


var life_label : Label
var console_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	life_label = $LifeLabel
	console_label = $ConsoleLabel

func set_life(life):
	life_label.text = "Life: " + str(life)+"%"

func setConsole(msg):
	console_label.text = msg
