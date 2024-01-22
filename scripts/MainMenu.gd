extends Control

@export var event : EventAsset

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://levels/lvl0.tscn")
	FMODRuntime.play_one_shot(event)

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	FMODRuntime.play_one_shot(event)

func _on_exit_button_pressed():
	get_tree().quit()
	FMODRuntime.play_one_shot(event)
