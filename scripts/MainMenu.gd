extends Control

@export var event : EventAsset

var fondo : TextureRect
var atlas : AtlasTexture

var timerAccumulator : float = 0
var timerInterval = 0.07
var iterator = 0

func _ready():
	fondo = $TextureRect
	atlas = fondo.texture

func _process(delta : float):
	timerAccumulator = timerAccumulator + delta
	if(timerAccumulator>=timerInterval):
		if(iterator > 4):
			iterator = 0
		else: 
			iterator = iterator +1
		drawNextFrame()
		timerAccumulator = 0
	

func drawNextFrame():
	if(iterator == 0):
		atlas.region.position.x = 0
		atlas.region.position.y = 0
	if(iterator == 1):
		atlas.region.position.x = 320
		atlas.region.position.y = 0
	if(iterator == 2):
		atlas.region.position.x = 640
		atlas.region.position.y = 0
	if(iterator == 3):
		atlas.region.position.x = 0
		atlas.region.position.y = 240
	if(iterator == 4):
		atlas.region.position.x = 320
		atlas.region.position.y = 240
	if(iterator == 5):
		atlas.region.position.x = 640
		atlas.region.position.y = 240

func _on_play_button_pressed():
	
	get_tree().change_scene_to_file("res://levels/lvl0.tscn")
	FMODRuntime.play_one_shot(event)

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	FMODRuntime.play_one_shot(event)

func _on_exit_button_pressed():
	get_tree().quit()
	FMODRuntime.play_one_shot(event)
