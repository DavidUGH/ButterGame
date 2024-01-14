extends CharacterBody2D

var speed: int
var life: int
var _sprite: AnimatedSprite2D
var player #El nivel tiene que inicializar al jugador

func _ready():
	speed = 120
	life = 2
	_sprite = $ButterboySprite
	
func _process(delta):
	_follow_player()
	move_and_slide()
	_handle_animations()
	
func _follow_player():
	var player_position = player.position
	var direction = (player_position - position).normalized()
	velocity = direction * speed

func _handle_animations():
	_sprite.play("moving")
