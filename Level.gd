class_name Level
extends Node

var powerup = preload("res://sprites/scenario/power_up.tscn")

enum SIDE {Top, Bottom, Left, Right}

var last_death = Vector2()
var enemy_death_count = 0
var enemies_list: Array = []
var butter_matrix : Array = []
var player
var tiles_to_win : float = 32*24 
var current_tiles : float = 0 
const BREAD_LAYER = 0
const BUTTER_LAYER = 2

var filas = 41
var columnas = 32

var tile_map : TileMap
var GUI
var _powerup_counter = 0
var enemies_till_powerup = 10


func set_tileset(t):
	tile_map = t

func set_player(p):
	player = p

func _game_over():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func have_won():
	if(current_tiles>=tiles_to_win):
		GUI.setConsole("You Win!")
		_game_over()

func spawn_powerups():
	if enemy_death_count % enemies_till_powerup == 0:
		print("new powerup")
		var new_powerup = powerup.instantiate()
		new_powerup.set_type(_powerup_counter)
		new_powerup.position = last_death
		call_deferred("add_child", new_powerup)
		_powerup_counter += 1
		if _powerup_counter > 2:
			_powerup_counter = 0

func get_random_coord_at_random_side(square_size):
	var sides = randi() % 4
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

func get_random_coord_outside_square_at_side(square_size, side : SIDE):
	var rand_position = Vector2()
	match side:
		SIDE.Top:
			rand_position = Vector2(randf_range(0, square_size.x), -10)
		SIDE.Left:
			rand_position = Vector2(-10, randf_range(0, square_size.y))
		SIDE.Right:
			rand_position = Vector2(square_size.x+10, randf_range(0, square_size.y))
		SIDE.Bottom:
			rand_position = Vector2(randf_range(0, square_size.x), square_size.y+10)
	return rand_position

# Función para realizar el spawn de una instancia de enemigo
func spawn_following_enemy_at(enemy_scene, enemy_position):
	var nueva_instancia = enemy_scene.instantiate()
	nueva_instancia.player = player
	nueva_instancia.position = enemy_position
	add_child(nueva_instancia)
	nueva_instancia.died.connect(_on_died)

	# Agregar la nueva instancia a la lista de enemigos
	enemies_list.append(nueva_instancia)

func spawn_passing_enemy_at(enemy_scene, initial_position, end_position):
	var nueva_instancia = enemy_scene.instantiate()
	nueva_instancia.player = player
	nueva_instancia.position = initial_position
	nueva_instancia.destination = end_position
	add_child(nueva_instancia)
	nueva_instancia.died.connect(_on_died)

	# Agregar la nueva instancia a la lista de enemigos
	enemies_list.append(nueva_instancia)

func _on_died(position_at_death):
	var tile = tile_map.local_to_map(position_at_death)
	draw_square(tile)
	enemy_death_count += 1
	last_death = position_at_death
	have_won()
	spawn_powerups()

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
	if(v.x>=8&&v.y>=7 && v.x<=39&&v.y<=30):#10,7 29,22
		if(butter_matrix[v.x][v.y] == 0):
			butter_matrix[v.x][v.y] = 1
			current_tiles = current_tiles+1
			vector.append(Vector2i(v.x, v.y))
		else:
			pass

func draw_circle(v: Vector2i):
	var x = v.x
	var y = v.y
	var vector: Array[Vector2i]
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

func draw_square(v: Vector2i):
	var x = v.x
	var y = v.y
	var vector: Array[Vector2i]
	check_tile(vector, Vector2i(x, y))
	check_tile(vector, Vector2i(x+1, y))
	check_tile(vector, Vector2i(x, y+1))
	check_tile(vector, Vector2i(x-1, y))
	check_tile(vector, Vector2i(x, y-1))
	check_tile(vector, Vector2i(x+1, y-1))
	check_tile(vector, Vector2i(x+1, y+1))
	check_tile(vector, Vector2i(x-1, y+1))
	check_tile(vector, Vector2i(x-1, y-1))
	tile_map.set_cells_terrain_connect(BUTTER_LAYER, vector, 0, 0, true)
