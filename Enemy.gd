class_name Enemy
extends CharacterBody2D

@export var hurt_sfx : EventAsset
@export var die_sfx : EventAsset

signal died(who, position_at_death)

enum TYPE {BB, SB, FB, N}
var enemy_type : TYPE
var speed: int
var life: int
var _sprite: AnimatedSprite2D
var lifeBar: ProgressBar
var player
var destination = Vector2(0,0)
enum STATE { hurt, moving, jumping, kicked, stunned}
var anim_state
var _hurtbox: Area2D
var _is_flashing : bool
var is_hurt = false
var damage : int
var is_jumping : bool
var is_kicked = false
var is_stunned = false
var knockback_amount : int
var knockback_reduction

func _despawn_if_out_of_view():
	var scz : Vector2
	scz.x = get_viewport().content_scale_size.x
	scz.y = get_viewport().content_scale_size.y
	if position.x >= scz.x+15 or position.x <= -15:
		queue_free()
	if position.y >= scz.y+15 or position.y <= -15:
		queue_free()

func _move(destination = Vector2(0,0)):
	if is_stunned:
		velocity = Vector2.ZERO
		return
	if destination == Vector2(0,0):
		destination = player.position
	var direction = (destination - position).normalized()
	velocity = direction * speed
	if is_kicked or is_hurt:
		direction = (player.position - position).normalized()
		var reduced_knockback_amount = knockback_amount * (1 - knockback_reduction / 100.0)
		velocity = ((direction * reduced_knockback_amount) * -1)

func _handle_animations():
	match anim_state:
		STATE.hurt:
			_sprite.play("hurt")
		STATE.moving:
			_sprite.play("moving")
		STATE.jumping:
			_sprite.play("jumping")
		STATE.kicked:
			_sprite.play("kicked")
		STATE.stunned:
			_sprite.play("stunned")

func _die():
	FMODRuntime.play_one_shot(die_sfx)
	died.emit(enemy_type, position)
	queue_free()

func _flash_white():
	if !_is_flashing:
		_sprite.material.set_shader_parameter("flash", true)
		_is_flashing = true
		await get_tree().create_timer(0.2).timeout
		_is_flashing = false
		_sprite.material.set_shader_parameter("flash", false)
		lifeBar.visible = false

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
	if is_kicked: # a bug was happening when enemies got attacked while in their kick animation
		is_kicked = false
	knockback_amount = player.knockback
	_flash_white()
	anim_state = STATE.hurt
	life -= player.damage
	lifeBar.value = life
	lifeBar.visible = true
	is_hurt = true
	FMODRuntime.play_one_shot(hurt_sfx)
	if life <= 0:
		_die()

func _get_kicked():
	knockback_amount = player.kick_knockback
	if knockback_amount >= 400 and enemy_type != TYPE.N:
		collision_mask = 32 #Can crash against wall
	_flash_white()
	anim_state = STATE.kicked
	life -= player.kick_damage
	is_kicked = true
	if life <= 0:
		_die()
