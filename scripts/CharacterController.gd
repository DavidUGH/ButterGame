extends CharacterBody2D

# Declare class variables here. Examples:
var speed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
var animated_sprite: AnimatedSprite2D
var jumpSFX: AudioStreamPlayer
var walkSFX : AudioStreamPlayer
var hitbox : CollisionShape2D
var area2d : Area2D
var anim_player : AnimationPlayer
var ouch : AudioStreamPlayer
var main_camera : Camera2D
var chromatic : ColorRect
var is_jumping = false
var walkSFX_finished = true
var animation_finished = true
var last_pitch = 1.0

var original_camera_position = Vector2(0, 0)
var shake_duration = 0.2
var shake_amplitude = 5.0
var shake_timer = 0.0

func _ready():
	animated_sprite = $AnimatedSprite2D
	jumpSFX = $JumpSFX
	walkSFX = $WalkSFX
	hitbox = $HitboxArea/Hitbox
	area2d = $HitboxArea
	anim_player = $AnimationPlayer
	ouch = $Ouch
	chromatic = get_parent().find_child("ChromaticAberration")
	main_camera = get_parent().find_child("Camera2D")

func _process(delta):
	var pitch_scale = 1.0
	# Process player input
	handle_input()
	randomize()
	# Move the player
	move_and_slide()
	if !is_jumping:
		if Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("down") or Input.is_action_pressed("up"):
			animation_finished = false
			animated_sprite.play("run")
			if walkSFX_finished:
				walkSFX_finished = false
				walkSFX.play()
		if !Input.is_anything_pressed():
			animated_sprite.play("idle")
			animation_finished = false
			walkSFX.stop()
			walkSFX_finished = true
		if Input.is_action_pressed("jump"):
			pitch_scale = randf_range(0.5, 0.9)
			is_jumping = true
			walkSFX_finished = true
			jumpSFX.pitch_scale = pitch_scale
			jumpSFX.play()
			area2d.set_collision_mask_value(2, false)
			animated_sprite.play("jump")
			walkSFX.stop()
	screen_shake(delta)
	if velocity.x > 0:
		animated_sprite.scale.x = 1
	elif velocity.x < 0:
		animated_sprite.scale.x = -1

# Handle player input
func handle_input():
	velocity = Vector2()  # Reset velocity

	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed

func get_hit():
	anim_player.play("hurt")
	ouch.play()
	hitbox.set_deferred("disabled", true)
	start_screen_shake()
	chromatic.visible = true

func _on_animated_sprite_2d_animation_looped():
	if is_jumping:
		is_jumping = false
		area2d.set_collision_mask_value(2, true)
	animation_finished = true

func _on_walk_sfx_finished():
	walkSFX_finished = true


func _on_area_2d_body_entered(body):
	get_hit()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt":
		hitbox.set_deferred("disabled", false)
	
func screen_shake(delta):
	if shake_timer > 0:
		# Generate a random offset for the camera position within the shake amplitude
		var offset = Vector2(randf_range(-shake_amplitude, shake_amplitude), randf_range(-shake_amplitude, shake_amplitude))
		
		# Apply the offset to the camera position
		main_camera.offset = offset

		# Decrease the shake timer
		shake_timer -= delta
	else:
		# Reset the camera position when the shake is complete
		main_camera.offset = original_camera_position
		chromatic.visible = false

func start_screen_shake():
	original_camera_position = main_camera.offset
	shake_timer = shake_duration
