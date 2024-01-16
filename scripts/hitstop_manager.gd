extends Node

func hitstop_short():
	get_tree().paused = true
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
