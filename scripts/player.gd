extends CharacterBody2D

enum WEAPON { knife }

var life: int
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

var _collision_box: CollisionShape2D
var _sprite: AnimatedSprite2D
var _player_hitbox: Area2D
var _player_hitbox_shape: CollisionShape2D


func _ready():
	#Instantiating child nodes
	_sprite = $PlayerAnimatedSprite
	_collision_box = $PlayerShape
	_player_hitbox = $PlayerHitbox
	_player_hitbox_shape = $PlayerHitbox/PlayerHitboxShape
	
	#Attribute initialization (placeholer values)
	speed = 200
	life = -1
	cadence = -1.0
	damage = -1
	weapon_kit = WEAPON.knife

func _process(delta):
	_move()
	_handle_animations()
	move_and_slide()
	

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
	
func _attack():
	pass
