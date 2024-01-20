extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://levels/lvl0.tscn")



func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
