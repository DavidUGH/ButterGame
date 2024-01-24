extends Control

var life_label : Label
var console_label: Label
var pause_menu:Control
var flag = false
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	life_label = $LifeLabel
	console_label = $ConsoleLabel
	pause_menu = $OptionsMenu
	pause_menu.gui = self

func _process(delta):
	if(flag&&i<1):
		pause_menu.position.y = lerp(-220, 50, i)
		print(pause_menu.position.y)
		i = i+0.03

func set_life(life):
	life_label.text = "Life: " + str(life)+"%"

func setConsole(msg):
	console_label.text = msg


func _on_texture_button_pressed():
	get_tree().paused = true
	flag = true
	

