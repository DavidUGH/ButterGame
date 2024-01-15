extends CharacterBody2D

enum WEAPON { knife }

var life : int
var speed: int
var cadence: float
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
	
	#Attribute initialization
	speed = 200
	life = 100
	cadence = -1.0
	damage = 1
	weapon_kit = WEAPON.knife
	
	#Preloading scenes
	weapon_swing = load("res://attack_effect.tscn")

func _process(delta):
	_move()
	_handle_animations()
	move_and_slide()
	_follow_mouse_with_weapon()

func _input(event):
	if event.is_action_pressed("attack"):
		if _weapon_sprite.get_children().is_empty(): 
			#If the knife has no children we know the attack is finished
			_attack()

func get_hurt(damage):
	life -= damage
	_animation_player.play("hurt")
	_player_hitbox.set_deferred("monitorable", false)
	print(life)

func _move():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _handle_animations():
	if velocity.x > 0 or velocity.y > 0:
		_sprite.play("run")
	else:
		_sprite.play("idle")

func _is_falling():
	pass
	
func _die():
	pass

func _follow_mouse_with_weapon():
	_weapon_sprite.look_at(get_viewport().get_mouse_position())
	
func _attack():
	var weapon_pos = _weapon_sprite.position
	var weapon_rot = _weapon_sprite.rotation
	var weapon_swing_spawn = weapon_swing.instantiate()
	_weapon_sprite.add_child(weapon_swing_spawn)
	weapon_swing_spawn.position = Vector2(weapon_pos.x+20, 0)
	weapon_swing_spawn.play("default")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"hurt":
			_player_hitbox.set_deferred("monitorable", true)
