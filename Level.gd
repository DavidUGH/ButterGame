class_name Level
extends Node

var enemies_list: Array = []
var player
var tiles_to_win = 0

var tile_map : TileMap

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func set_tileset(t):
	tile_map = t

func set_player(p):
	player = p

func have_we_won(layer):
	var used_tiles = []
	used_tiles = tile_map.get_used_cells(layer)
	print(used_tiles.size())
	if used_tiles.size() > tiles_to_win:
		print("You win!")

# Función para realizar el spawn de una instancia de enemigo
func spawn_enemy(enemy_scene):
	var nueva_instancia = enemy_scene.instantiate()
	nueva_instancia.player = player
	nueva_instancia.position = Vector2(randf_range(0, 1280), randf_range(0, 720))
	add_child(nueva_instancia)
	nueva_instancia.died.connect(_on_died)

	# Agregar la nueva instancia a la lista de enemigos
	enemies_list.append(nueva_instancia)

func _on_died(position_at_death):
	var tile = tile_map.local_to_map(position_at_death)
	draw_cross(tile)

func draw_cross(v: Vector2i):
	var x = v.x
	var y = v.y
	var vector: Array[Vector2i]
	vector.append(Vector2i(x-1, y))
	vector.append(Vector2i(x, y))
	vector.append(Vector2i(x+1, y))
	vector.append(Vector2i(x, y+1))
	vector.append(Vector2i(x, y-1))
	tile_map.set_cells_terrain_connect(0, vector, 0, 0, true)
