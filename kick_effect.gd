extends AnimatedSprite2D

func _enter_tree():
	play("default")

func _on_animation_finished():
	queue_free()
