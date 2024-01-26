extends Control

@export var event : EventAsset

var fondo : TextureRect
var atlas : AtlasTexture
var splash: TextureRect

var timerAccumulator : float = 0
var timerInterval = 0.07
var songInterval = 3
var iterator = 0
var hasSplash = false

func _ready():
	fondo = $TextureRect
	atlas = fondo.texture
	splash = $Splash

func _process(delta : float):
	if(hasSplash):
		timerAccumulator = timerAccumulator + delta
		if(timerAccumulator>=timerInterval):
			if(iterator > 4):
				iterator = 0
			else: 
				iterator = iterator +1
			drawNextFrame()
			timerAccumulator = 0
	else:
		timerAccumulator = timerAccumulator + delta
		if(timerAccumulator >= songInterval):
			splash.visible = false
			hasSplash = true
			timerAccumulator = 0
	

func drawNextFrame():
	atlas.region.position.x = 400*iterator

func _on_play_button_pressed():
	$ColorRect.visible = true
	$AnimationPlayer.play("fadeout")
	FMODRuntime.play_one_shot(event)

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	FMODRuntime.play_one_shot(event)

func _on_exit_button_pressed():
	get_tree().quit()
	FMODRuntime.play_one_shot(event)


func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://levels/lvl0.tscn")
	FMODRuntime.play_one_shot(event)
