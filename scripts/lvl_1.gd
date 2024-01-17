extends Level

var enemy_scen = preload("res://butterboy.tscn")
var _spawn_flag: bool = false

func _ready():
	set_player($Player)
	set_stain_tileset($StainedTileMap)
	set_bread_tileset($BreadTileMap)
	tiles_to_win = 30
	var cells = _bread_tile_map.get_used_cells(0)
	cells.sort()
	print(cells)

func _process(delta):
	if Input.is_key_pressed(KEY_F):
		if !_spawn_flag:
			_spawn_flag = true
			spawn_enemy(enemy_scen)
	else:
		_spawn_flag = false
