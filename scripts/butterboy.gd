extends CharacterBody2D

var speed: int
var life: int
var _sprite: AnimatedSprite2D
var player #El nivel tiene que inicializar al jugador
enum STATE { hurt, moving }
var anim_state
var tile_map

var _hurtbox: Area2D

func _ready():
	speed = 60
	life = 2
	_sprite = $ButterboySprite
	_hurtbox = $Hurtbox
	
	anim_state = STATE.moving
	
func _process(delta):
	_follow_player()
	move_and_slide()
	_handle_animations()
	_die()
	
func _follow_player():
	var player_position = player.position
	var direction = (player_position - position).normalized()
	velocity = direction * speed

func _handle_animations():
	match anim_state:
		STATE.hurt:
			_sprite.play("hurt")
		STATE.moving:
			_sprite.play("moving")

func _die():
	var tile
	if life <= 0:
		
		tile = tile_map.local_to_map(position)
		print(tile)
		tile_map.set_cell(1, tile, 1, Vector2i(4,0))
		queue_free()

func _get_hurt():
	anim_state = STATE.hurt
	life -= player.damage
	_sprite.material.set_shader_parameter("flash", true)
	await get_tree().create_timer(0.05).timeout
	_sprite.material.set_shader_parameter("flash", false)

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
