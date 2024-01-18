extends Level

var _enemy_spawn_flag = false
var butterboy = preload("res://butterboy.tscn")

func _ready():
	player = $Player
	tile_map = $TileMap
	tiles_to_win = 144

func _process(delta):
	if(Input.is_key_pressed(KEY_F)):
		if(!_enemy_spawn_flag):
			_enemy_spawn_flag = true
			spawn_enemy(butterboy)
	else:
		_enemy_spawn_flag = false
