extends AnimatedSprite2D

func _enter_tree():
	$AnimationPlayer.play("active_frames")

func _on_animation_finished():
	queue_free()
