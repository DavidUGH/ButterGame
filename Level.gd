class_name Level
extends Node

var enemies_list: Array = []
var butter_matrix : Array = []
var player
var tiles_to_win = 16*20
var current_tiles = 0
const BREAD_LAYER = 0
const BUTTER_LAYER = 2

var filas = 31
var columnas = 24

var tile_map : TileMap


func set_tileset(t):
	tile_map = t

func set_player(p):
	player = p

func have_won():
	print("CURRENT TILES: "+ str(current_tiles))
	print("TILES TO WIN: "+ str(tiles_to_win))
	if(current_tiles>=tiles_to_win):
		print("You Win!")

func _get_random_coord_outside_square(square_size):
	var sides = randi() % 1
	var rand_position = Vector2()
	match sides:
		0: #top
			rand_position = Vector2(randf_range(0, square_size.x), -10)
		1: #left
			rand_position = Vector2(-10, randf_range(0, square_size.y))
		2: #right
			rand_position = Vector2(square_size.x+10, randf_range(0, square_size.y))
		3: #down
			rand_position = Vector2(randf_range(0, square_size.x), square_size.y+10)
	return rand_position

# Función para realizar el spawn de una instancia de enemigo
func spawn_enemy(enemy_scene):
	var nueva_instancia = enemy_scene.instantiate()
	nueva_instancia.player = player
	nueva_instancia.position = _get_random_coord_outside_square(get_viewport().content_scale_size)
	add_child(nueva_instancia)
	nueva_instancia.died.connect(_on_died)

	# Agregar la nueva instancia a la lista de enemigos
	enemies_list.append(nueva_instancia)

func _on_died(position_at_death):
	var tile = tile_map.local_to_map(position_at_death)
	draw_circle(tile)
	have_won()

func draw_cross(v: Vector2i):
	var x = v.x
	var y = v.y
	var vector: Array[Vector2i]
	check_tile(vector, Vector2i(x, y))
	check_tile(vector, Vector2i(x+1, y))
	check_tile(vector, Vector2i(x, y+1))
	check_tile(vector, Vector2i(x-1, y))
	check_tile(vector, Vector2i(x, y-1))
	tile_map.set_cells_terrain_connect(BUTTER_LAYER, vector, 0, 0, true)

func check_tile(vector:Array[Vector2i], v:Vector2i):
	if(v.x>=10&&v.y>=7 && v.x<=29&&v.y<=22):#10,7 29,22
		if(butter_matrix[v.x][v.y] == 0):
			butter_matrix[v.x][v.y] = 1
			current_tiles = current_tiles+1
			vector.append(Vector2i(v.x, v.y))
		else:
			print("Hi")

func draw_circle(v: Vector2i):
	var x = v.x
	var y = v.y
	var vector: Array[Vector2i]
	# Esto es horrible pero no se me ocurre como más hacerle
	check_tile(vector, Vector2i(x, y))
	check_tile(vector, Vector2i(x+1, y))
	check_tile(vector, Vector2i(x+2, y))
	check_tile(vector, Vector2i(x, y+1))
	check_tile(vector, Vector2i(x, y+2))
	check_tile(vector, Vector2i(x-1, y))
	check_tile(vector, Vector2i(x-2, y))
	check_tile(vector, Vector2i(x, y-1))
	check_tile(vector, Vector2i(x, y-2))
	check_tile(vector, Vector2i(x+1, y-1))
	check_tile(vector, Vector2i(x+1, y+1))
	check_tile(vector, Vector2i(x-1, y+1))
	check_tile(vector, Vector2i(x-1, y-1))
	tile_map.set_cells_terrain_connect(BUTTER_LAYER, vector, 0, 0, true)
