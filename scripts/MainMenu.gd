extends Control

@export var event : EventAsset

var fondo : TextureRect
var atlas : AtlasTexture

func _process(delta):
	fondo = $TextureRect
	atlas = fondo.texture
	atlas.draw_rect_region(atlas.get_rid(), Rect2(0,0,320,240), Rect2(0,0,320,240))

func _on_play_button_pressed():
	
	get_tree().change_scene_to_file("res://levels/lvl0.tscn")
	FMODRuntime.play_one_shot(event)

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	FMODRuntime.play_one_shot(event)

func _on_exit_button_pressed():
	get_tree().quit()
	FMODRuntime.play_one_shot(event)
