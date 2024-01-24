extends Control

var life_label : Label
var console_label: Label
var pause_menu:Control
var lifeBar:TextureProgressBar
var staminaBar: TextureProgressBar
var butterBar: TextureProgressBar
var flag = false
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	life_label = $LifeLabel
	console_label = $ConsoleLabel
	pause_menu = $OptionsMenu
	pause_menu.gui = self
	lifeBar = $LifeBar
	staminaBar = $StaminaBar
	butterBar = $ButterBar

func _process(delta):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		showPauseMenu()
	if(flag&&i<1):
		pause_menu.position.y = lerp(-220, 50, i)
		i = i+0.03

func set_life(life):
	lifeBar.value = life
	staminaBar.value = life
	life_label.text = "Life: " + str(life)+"%"

func setConsole(msg):
	console_label.text = msg

func setButterProgress(v):
	butterBar.value = v

func _on_texture_button_pressed():
	showPauseMenu()

func showPauseMenu():
	get_tree().paused = true
	flag = true
