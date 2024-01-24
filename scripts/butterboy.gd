extends Enemy

func _ready():
	speed = 60
	life = 4
	damage = 10
	_is_flashing = false
	_sprite = $ButterboySprite
	_hurtbox = $Hurtbox
	is_jumping = false
	anim_state = STATE.moving
	
func _physics_process(delta):
	if !is_jumping:
		_move(destination	)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	_handle_animations()
	_despawn_if_out_of_view()

func _on_hurtbox_area_entered(area): 
	var parent_name = area.get_parent().name
	match parent_name:
		"Player":
			player.get_hurt(damage)
		"AttackEffect":
			_get_hurt()
		"KickEffect":
			_get_kicked()

func _on_butterboy_sprite_animation_finished():
	if anim_state == STATE.hurt:
		anim_state = STATE.moving
		is_hurt = false
	if anim_state == STATE.jumping:
		anim_state = STATE.moving
		is_jumping = false
		_hurtbox.set_deferred("monitoring", true)
