extends Node

var enemies_list: Array = []
var player
var flag:bool = false

var _stained_tile_map : TileMap

func _ready():
	player = $Player
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	_stained_tile_map = $StainedTileMap
	
func _process(delta):
	if(Input.is_key_pressed(KEY_F)):
		if(!flag):
			flag = true
			spawn_enemy($Butterboy)
	else:
		flag = false

func set_tileset(t):
	_stained_tile_map = t

func set_player(p):
	player = p

func have_we_won():
	var used_tiles = []
	used_tiles = _stained_tile_map.get_used_cells(0)
	print(used_tiles.size())
	if used_tiles.size()/4 > 5:
		print("You win!")
	
# Función para realizar el spawn de una instancia de enemigo
func spawn_enemy(enemy):
	var nueva_instancia = enemy.instantiate()
	print(player)
	nueva_instancia.player = player
	nueva_instancia.tile_map_to_stain = _stained_tile_map
	nueva_instancia.position = Vector2(randf_range(0, 1280), randf_range(0, 720))
	add_child(nueva_instancia)

	# Agregar la nueva instancia a la lista de enemigos
	enemies_list.append(nueva_instancia)
