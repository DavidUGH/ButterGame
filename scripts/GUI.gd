extends Control

var life_label : Label
var console_label: Label
var pause_menu:Control
var lifeBar:TextureProgressBar
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
	pause_menu.music_volume.value = BankManager.get_music_volume()
	pause_menu.sfx_volume.value = BankManager.get_sfx_volume()
	lifeBar = $LifeBar
	butterBar = $ButterBar

func _process(delta):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		showPauseMenu()
	if(flag&&i<1):
		pause_menu.position.y = lerp(-220, 50, i)
		i = i+0.03

func set_life(life):
	lifeBar.value = life
	life_label.text = "Life: " + str(life)+"%"

func setConsole(msg):
	console_label.text = msg

func setButterProgress(v:int):
	butterBar.value = v
	$progressLabel.text = str(v)+"%"

func _on_texture_button_pressed():
	showPauseMenu()

func showPauseMenu():
	get_tree().paused = true
	flag = true
