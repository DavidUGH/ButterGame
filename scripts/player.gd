extends CharacterBody2D

signal died

enum WEAPON { knife }

var life : int
var speed: int
var attack_speed: float
var damage: int
var weapon_kit: WEAPON
var can_walk: bool
var can_attack: bool
var is_attacking: bool
var is_hurting: bool
var can_be_hurt: bool
var is_slippery: bool
var is_power_up_anim: bool
var is_falling: bool
var invis_frames = 2
var weapon_swing

var _weapon_sprite: Sprite2D
var _collision_box: CollisionShape2D
var _sprite: AnimatedSprite2D
var _player_hitbox: Area2D
var _player_hitbox_shape: CollisionShape2D
var _animation_player: AnimationPlayer


func _ready():
	#Instantiating child nodes
	_sprite = $PlayerAnimatedSprite
	_collision_box = $PlayerShape
	_player_hitbox = $PlayerHitbox
	_player_hitbox_shape = $PlayerHitbox/PlayerHitboxShape
	_weapon_sprite = $KnifeSprite
	_animation_player = $AnimationPlayer
	is_hurting = false
	#Attribute initialization
	speed = 200
	life = 100
	attack_speed = 0.2
	damage = 1
	weapon_kit = WEAPON.knife
	
	#Loading scenes to instance
	weapon_swing = load("res://attack_effect.tscn")

func _process(delta):
	_move()
	_handle_animations()
	move_and_slide()
	_follow_mouse_with_weapon()
	_attack()

func get_hurt(damage):
	if !is_hurting:
		life -= damage
		if life <= 0:
			_die()
		HitstopManager.hitstop_short()
		_animation_player.play("hurt")
		is_hurting = true
		_player_hitbox.set_deferred("monitorable", false)
		await get_tree().create_timer(invis_frames).timeout
		_animation_player.stop()
		is_hurting = false
		_player_hitbox.set_deferred("monitorable", true)
		_is_still_colliding()

func _is_still_colliding():
	var overlapping = _player_hitbox.get_overlapping_areas()
	if !overlapping.is_empty():
		#No me gusta hacer esto pero ya que
		get_hurt(overlapping[0].get_parent().damage)

func _move():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		_sprite.scale.x = 1
		velocity.x += 1
	if Input.is_action_pressed("left"):
		_sprite.scale.x = -1
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _handle_animations():
	if velocity.x != 0 or velocity.y != 0:
		_sprite.play("run")
	else:
		_sprite.play("idle")

func _is_falling():
	pass
	
func _die():
	print("I'm dead")
	died.emit()

func _follow_mouse_with_weapon():
	_weapon_sprite.look_at(get_viewport().get_mouse_position())

func _attack():
	if Input.is_action_just_pressed("attack") and !is_attacking:
		var weapon_pos = _weapon_sprite.position
		var weapon_rot = _weapon_sprite.rotation
		var weapon_swing_spawn = weapon_swing.instantiate()
		_weapon_sprite.add_child(weapon_swing_spawn)
		weapon_swing_spawn.position = Vector2(weapon_pos.x+20, 0)
		weapon_swing_spawn.play("default")
		is_attacking = true
		await get_tree().create_timer(attack_speed).timeout
		is_attacking = false
