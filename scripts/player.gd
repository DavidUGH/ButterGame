extends CharacterBody2D

@export var walk_sfx : EventAsset
@export var attack_sfx : EventAsset
@export var hurt_sfx : EventAsset
@export var powerup_sfx : EventAsset

signal died
signal special_kick
signal hurt

enum WEAPON { knife }

var life : int
var stamina : int
var speed: int
var attack_speed: float
var damage: int
var kick_damage: int
var knockback: float
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
var special_kick_swing
var _is_kicking: bool = false
var gui
var kick_knockback : float

var _weapon_sprite : Sprite2D
var _collision_box: CollisionShape2D
var _sprite: AnimatedSprite2D
var _shadow: Sprite2D
var _player_hitbox: Area2D
var _player_hitbox_shape: CollisionShape2D
var _hurt_animation_player: AnimationPlayer
var _charge_animation_player : AnimationPlayer
var _has_played_walk_sfx = false

var hold_duration = 0
const BASE_SPEED = 100

func _ready():
	#Instantiating child nodes
	_sprite = $PlayerAnimatedSprite
	_shadow = $Sprite2D
	_collision_box = $PlayerShape
	_player_hitbox = $PlayerHitbox
	_player_hitbox_shape = $PlayerHitbox/PlayerHitboxShape
	_weapon_sprite = $Pointer
	_hurt_animation_player = $HurtAnimationPlayer
	_charge_animation_player = $ChargeAnimationPlayer
	is_hurting = false
	#Attribute initialization
	speed = 100
	life = 100
	stamina = 100
	attack_speed = 0.2
	damage = 3
	kick_damage = 2
	kick_knockback = 180
	knockback = 30
	weapon_kit = WEAPON.knife
	
	#Loading scenes to instance
	weapon_swing = load("res://attack_effect.tscn")
	kick_swing = load("res://kick_effect.tscn")
	special_kick_swing = load("res://special_kick_effect.tscn")

func _process(delta):
	_move()
	_handle_animations()
	move_and_slide()
	_follow_mouse_with_weapon()
	_attack()
	_kick(delta)

func get_hurt(damage):
	if !is_hurting:
		life -= damage
		gui.set_life(life)
		if life <= 0:
			gui.set_life(0)
			_die()
		hurt.emit()
		#_start_screen_shake()
		HitstopManager.hitstop_short()
		_hurt_animation_player.play("hurt")
		FMODRuntime.play_one_shot(hurt_sfx)
		is_hurting = true
		_player_hitbox.set_deferred("monitorable", false)
		await get_tree().create_timer(invis_frames).timeout
		_hurt_animation_player.stop()
		is_hurting = false
		_player_hitbox.set_deferred("monitorable", true)
		handle_collision_of_overlapping_areas()

func handle_collision_of_overlapping_areas():
	var overlapping = _player_hitbox.get_overlapping_areas()
	if !overlapping.is_empty():
		var overlapper = overlapping[0].get_parent()
		print(overlapper.name)
		if overlapper.name == "Butterboy":
			#No me gusta hacer esto pero ya que
			get_hurt(overlapper.damage)

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
		_shadow.scale.x = _shadow.scale.x * -1
		_play_walk_sfx()
		velocity.x += 1
	if Input.is_action_pressed("left"):
		_sprite.scale.x = -1
		_shadow.scale.x = _shadow.scale.x * -1
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

func _kick(delta):
	if _is_kicking: return
	if Input.is_action_pressed("secondary_attack"):
		hold_duration += delta
		if hold_duration > 0.1:
			_charge_animation_player.play("charging")
			#speed = 0
		if hold_duration >= 1:
			_charge_animation_player.stop()
			_sprite.self_modulate = Color(1, 6.51, 2.96)
	if Input.is_action_just_released("secondary_attack"):
		print(hold_duration)
		speed = BASE_SPEED
		_charge_animation_player.stop()
		if hold_duration <= 0.3:
			_spawn_kick()
		elif hold_duration <= 0.5:
			_spawn_kick(250, 0.5, 1.4)
		elif hold_duration < 0.8:
			_spawn_kick(310, 0.6, 1.8)
		elif hold_duration >= 0.8:
			_special_kick()
		hold_duration = 0
		

func _spawn_kick(new_knockback = 210, cooldown = 0.2, new_scale = 1):
	var new_scale_v = Vector2(new_scale, new_scale)
	var kick_swing_spawn = kick_swing.instantiate()
	kick_knockback = new_knockback
	add_child(kick_swing_spawn)
	var x = _weapon_sprite.position.x
	var y = _weapon_sprite.position.y
	kick_swing_spawn.position.x = x + 40 * cos(_weapon_sprite.rotation)
	kick_swing_spawn.position.y = y + 40 * sin(_weapon_sprite.rotation)
	kick_swing_spawn.rotation = _weapon_sprite.rotation
	kick_swing_spawn.scale = new_scale_v
	_is_kicking = true
	await get_tree().create_timer(cooldown).timeout
	_is_kicking = false

func _special_kick():
	special_kick.emit()
	var kick_swing_spawn = special_kick_swing.instantiate()
	kick_knockback = 400
	add_child(kick_swing_spawn)
	var x = _weapon_sprite.position.x
	var y = _weapon_sprite.position.y
	kick_swing_spawn.position.x = x + 40 * cos(_weapon_sprite.rotation)
	kick_swing_spawn.position.y = y + 40 * sin(_weapon_sprite.rotation)
	kick_swing_spawn.rotation = _weapon_sprite.rotation
	_is_kicking = true
	await get_tree().create_timer(1).timeout
	_is_kicking = false

func _on_player_hitbox_area_entered(area):
	var parent = area.get_parent()
	if area.collision_layer == 256: # Si la collision layer tiene el bit 8 y solo el bit 8
		FMODRuntime.play_one_shot(powerup_sfx)
		match parent.stat_type:
			parent.TYPE.Damage:
				damage += parent.pick_up()
				parent.queue_free()
			parent.TYPE.AS:
				attack_speed -= parent.pick_up()
				parent.queue_free()
			parent.TYPE.MS:
				speed += parent.pick_up()
				parent.queue_free()
			_:
				print("This shouldn't happen")
