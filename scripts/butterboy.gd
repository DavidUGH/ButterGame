extends CharacterBody2D

var speed: int
var life: int
var _sprite: AnimatedSprite2D
var player #El nivel tiene que inicializar al jugador
enum STATE { hurt, moving }
var anim_state

func _ready():
	speed = 120
	life = 2
	_sprite = $ButterboySprite
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
	if life <= 0:
		queue_free()

func _get_hurt():
	anim_state = STATE.hurt
	life -= player.damage

func _on_hurtbox_area_entered(area):
	_get_hurt()

func _on_butterboy_sprite_animation_finished():
	if anim_state == STATE.hurt:
		anim_state = STATE.moving
