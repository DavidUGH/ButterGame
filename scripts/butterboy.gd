extends CharacterBody2D

var speed: int
var life: int
var _sprite: AnimatedSprite2D
var player #El nivel tiene que inicializar al jugador

func _ready():
	speed = 60
	life = 2
	_sprite = $ButterboySprite
	
func _process(delta):
	_follow_player()
	move_and_slide()
	_handle_animations()
	
func _follow_player():
	var player_position = player.position
	var the_vector = Vector2()
	the_vector.x = player_position.x - position.x
	the_vector.y = player_position.y - position.y
	velocity = Vector2()
	velocity.x += tanh(the_vector.x) #tanh maps real numbers to 1 or -1
	velocity.y += tanh(the_vector.y)
	print(the_vector)
	velocity = velocity * speed

func _handle_animations():
	_sprite.play("moving")
