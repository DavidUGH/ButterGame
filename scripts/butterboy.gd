extends CharacterBody2D

signal died(position_at_death)

var speed: int
var friction: float
var life: int
var _sprite: AnimatedSprite2D
var player
enum STATE { hurt, moving, jumping}
var anim_state
var _hurtbox: Area2D
var _is_flashing : bool
var is_hurt = false
var damage : int
var is_jumping : bool
var knockback_amount : int

func _ready():
	speed = 60
	life = 4
	friction = 10
	damage = 10
	_is_flashing = false
	_sprite = $ButterboySprite
	_hurtbox = $Hurtbox
	is_jumping = false
	anim_state = STATE.moving
	
func _physics_process(delta):
	if !is_jumping:
		_follow_player(delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	_handle_animations()
	
func _follow_player(delta):
	var player_position = player.position
	var direction = (player_position - position).normalized()
	velocity = direction * speed
	if is_hurt:
		velocity = (direction * knockback_amount) * -1

func _handle_animations():
	match anim_state:
		STATE.hurt:
			_sprite.play("hurt")
		STATE.moving:
			_sprite.play("moving")
		STATE.jumping:
			_sprite.play("jumping")

func _die():
	died.emit(position)
	queue_free()

func _flash_white():
	if !_is_flashing:
		_sprite.material.set_shader_parameter("flash", true)
		_is_flashing = true
		await get_tree().create_timer(0.2).timeout
		_is_flashing = false
		_sprite.material.set_shader_parameter("flash", false)

func jump():
	is_jumping = true
	anim_state = STATE.jumping
	var character_size = Vector2(0,0)
	if velocity.x > 0:
		character_size = Vector2(20, 0)
	if velocity.x < 0:
		character_size = Vector2(-20, 0)
	if velocity.y > 0:
		character_size = Vector2(0, 0)
	if velocity.y < 0:
		character_size = Vector2(0, -20)
	var new_position = position+velocity+character_size
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, 0.5)
	var sprite_position = _sprite.position
	var sprite_tween = get_tree().create_tween()
	sprite_tween.tween_property(_sprite, "position", Vector2(0,sprite_position.y-10), 0.25)
	sprite_tween.tween_property(_sprite, "position", sprite_position, 0.25)
	_hurtbox.set_deferred("monitoring", false)

func _get_hurt():
	knockback_amount = 20
	_flash_white()
	anim_state = STATE.hurt
	life -= player.damage
	is_hurt = true
	if life <= 0:
		_die()

func _get_kicked():
	knockback_amount = 150
	_flash_white()
	anim_state = STATE.hurt
	life -= player.damage
	is_hurt = true
	if life <= 0:
		_die()

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
