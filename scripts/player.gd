extends CharacterBody2D

@export var walk_sfx : EventAsset
@export var attack_sfx : EventAsset
@export var hurt_sfx : EventAsset

signal died

enum WEAPON { knife }

var life : int
var speed: int
var attack_speed: float
var damage: int
var kick_damage: int
var knockback: int
var kick_knockback: int
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
var kick_swing
var _is_kicking: bool = false
var gui

var camera2d : Camera2D
var _weapon_sprite : Sprite2D
var _collision_box: CollisionShape2D
var _sprite: AnimatedSprite2D
var _player_hitbox: Area2D
var _player_hitbox_shape: CollisionShape2D
var _animation_player: AnimationPlayer
var _has_played_walk_sfx = false

var _original_camera_position = Vector2(0, 0)
var _shake_timer = 0.0
var _shake_duration = 0.2

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
	speed = 150
	life = 100
	attack_speed = 0.2
	damage = 2
	kick_damage = 1
	weapon_kit = WEAPON.knife	
	
	#Loading scenes to instance
	weapon_swing = load("res://attack_effect.tscn")
	kick_swing = load("res://kick_effect.tscn")

func _process(delta):
	_move()
	_handle_animations()
	move_and_slide()
	_follow_mouse_with_weapon()
	_attack()
	_kick()
	_screen_shake(delta)

func get_hurt(damage):
	if !is_hurting:
		life -= damage
		gui.set_life(life)
		if life <= 0:
			gui.set_life(0)
			_die()
		_start_screen_shake()
		HitstopManager.hitstop_short()
		_animation_player.play("hurt")
		FMODRuntime.play_one_shot(hurt_sfx)
		is_hurting = true
		_player_hitbox.set_deferred("monitorable", false)
		await get_tree().create_timer(invis_frames).timeout
		_animation_player.stop()
		is_hurting = false
		_player_hitbox.set_deferred("monitorable", true)
		handle_collision_of_overlapping_areas()

func _screen_shake(delta):
	if _shake_timer > 0:
		var _shake_amplitude = 2.0
		# Generate a random offset for the camera position within the shake amplitude
		var offset = Vector2(randf_range(-_shake_amplitude, _shake_amplitude), randf_range(-_shake_amplitude, _shake_amplitude))
		
		# Apply the offset to the camera position
		camera2d.offset = offset

		# Decrease the shake timer
		_shake_timer -= delta
	else:
		# Reset the camera position when the shake is complete
		camera2d.offset = _original_camera_position

func _start_screen_shake():
	_original_camera_position = camera2d.offset
	_shake_timer = _shake_duration

func handle_collision_of_overlapping_areas():
	var overlapping = _player_hitbox.get_overlapping_areas()
	if !overlapping.is_empty():
		#No me gusta hacer esto pero ya que
		get_hurt(overlapping[0].get_parent().damage)

func _play_walk_sfx():
	if !_has_played_walk_sfx:
		_has_played_walk_sfx = true
		FMODRuntime.play_one_shot(walk_sfx)
		await get_tree().create_timer(0.2).timeout
		_has_played_walk_sfx = false

func _move():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		_sprite.scale.x = 1
		_play_walk_sfx()
		velocity.x += 1
	if Input.is_action_pressed("left"):
		_sprite.scale.x = -1
		velocity.x -= 1
		_play_walk_sfx()
	if Input.is_action_pressed("down"):
		velocity.y += 1
		_play_walk_sfx()
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		_play_walk_sfx()
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
		var weapon_swing_spawn = weapon_swing.instantiate()
		add_child(weapon_swing_spawn)
		var x = _weapon_sprite.position.x
		var y = _weapon_sprite.position.y
		weapon_swing_spawn.position.x = x + 40 * cos(_weapon_sprite.rotation)
		weapon_swing_spawn.position.y = y + 40 * sin(_weapon_sprite.rotation)
		weapon_swing_spawn.rotation = _weapon_sprite.rotation
		FMODRuntime.play_one_shot(attack_sfx)
		weapon_swing_spawn.play("default")
		is_attacking = true
		await get_tree().create_timer(attack_speed).timeout
		is_attacking = false

func _kick():
	if Input.is_action_just_pressed("secondary_attack") and !_is_kicking:
		var kick_swing_spawn = kick_swing.instantiate()
		add_child(kick_swing_spawn)
		var x = _weapon_sprite.position.x
		var y = _weapon_sprite.position.y
		kick_swing_spawn.position.x = x + 40 * cos(_weapon_sprite.rotation)
		kick_swing_spawn.position.y = y + 40 * sin(_weapon_sprite.rotation)
		kick_swing_spawn.rotation = _weapon_sprite.rotation
		_is_kicking = true
		await get_tree().create_timer(1).timeout
		_is_kicking = false
