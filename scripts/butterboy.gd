extends CharacterBody2D

signal died(position_at_death)

var speed: int
var friction: float
var life: int
var _sprite: AnimatedSprite2D
var player #El nivel tiene que inicializar al jugador
enum STATE { hurt, moving }
var anim_state
var _hurtbox: Area2D
var _is_flashing : bool
var is_hurt = false

func _ready():
	speed = 60
	life = 4
	friction = 10
	_is_flashing = false
	_sprite = $ButterboySprite
	_hurtbox = $Hurtbox
	anim_state = STATE.moving
	
func _physics_process(delta):
	_follow_player(delta)
	move_and_slide()
	_handle_animations()
	
func _follow_player(delta):
	var player_position = player.position
	var direction = (player_position - position).normalized()
	velocity = direction * speed
	if is_hurt:
		velocity = (direction * 20) * -1

func _handle_animations():
	match anim_state:
		STATE.hurt:
			_sprite.play("hurt")
		STATE.moving:
			_sprite.play("moving")

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

func _get_hurt():
	_flash_white()
	anim_state = STATE.hurt
	life -= player.damage
	is_hurt = true
	if life <= 0:
		_die()

func _on_hurtbox_area_entered(area): 
	# Collision layers and masks are actually 32 bit binary strings. Each bit
	# represents a different layer. For example: Layer 3 is bit 2. If bit 2 is
	# set to 1 then that object is on collision layer 3.
	
	# Because of this, you can read collision layers as integers. An object
	# in collision layer 3 would have a binary string of 100, which is 4 in decimal.
	
	# if there is a better way of doing this, please find one.
	match area.get_collision_layer():
		1: #Player layer
			player.get_hurt(10)
		4: #Player attack layer
			_get_hurt()

func _on_butterboy_sprite_animation_finished():
	if anim_state == STATE.hurt:
		anim_state = STATE.moving
		is_hurt = false
