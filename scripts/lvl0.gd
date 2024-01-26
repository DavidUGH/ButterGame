extends Level

var napkins = []
var spawn_flag = true
var butterboy = preload("res://butterboy.tscn")
var fattyBoy = preload("res://scenes/FattyBoy.tscn")
var skinnyBoy = preload("res://scenes/SkinnyBoy.tscn")
var napkin = preload("res://napkin.tscn")
var screen_size
var timer : Timer
var time_counter
var physics_bounds : StaticBody2D

var camera2d : Camera2D
var _shake_timer = 0.0
var _shake_duration = 0.2
var _shake_amplitude = 2
var _original_camera_position = Vector2(0, 0)

var queue = []

func _ready():
	for i in range(filas):
		var fila: Array = []
		for j in range(columnas):
			fila.append(0)
		butter_matrix.append(fila)
	player = $Player
	player.hurt.connect(_on_player_hurt)
	player.died.connect(_on_player_died)
	player.special_kick.connect(_on_player_special_kick)
	tile_map = $TileMap
	timer = $Timer
	GUI = $GUI
	player.gui = GUI
	camera2d = $Camera2D
	time_counter = 3.0
	screen_size = get_viewport().content_scale_size

func _process(delta):
	timeline(timer.time)
	spawn_enemies_periodically()
	_screen_shake(delta)
	_count_napkins()
	_clean_butter_below_napkins()
	var minutes = floor(timer.time_left / 60)
	var seconds = floor(timer.time_left - minutes * 60)
	GUI.setConsole(str(minutes) + ":" + time_format(seconds))

func time_format(time):
	if time < 10:
		return "0" + str(time)
	return str(time)

func timeline(time):
	if time == 0: #time_counter = 3
		queue.push_back(0) # 0
		queue.push_back(0) # 3
		queue.push_back(0) # 6
		queue.push_back(0) # 9
		queue.push_back(1) # 12
		queue.push_back(0) # 15
		queue.push_back(1) # 18
		queue.push_back(0) # 21
	if time == 20:
		queue.push_back(0)
		queue.push_back(0)
func spawn_enemies_periodically():
	if spawn_flag:
		var next = queue.pop_front()
		spawn_wave(next)
		spawn_flag = false
		await get_tree().create_timer(time_counter).timeout
		spawn_flag = true

func spawn_wave(next):
	match next:
		0: # followers at random
			spawn_followers_from_random_side()
		1: # passing random side
			spawn_passing_enemies_from_random_side()
		2: # passing cross top and bottom
			spawn_passing_enemies_cross(0)
		3: # passing cross left and right
			spawn_passing_enemies_cross(1)

func spawn_passing_enemies_cross(side):
	match side:
		0: # vertical
			spawn_passing_top_to_bottom()
			spawn_passing_bottom_to_top()
		1: # horizontal
			spawn_passing_left_to_right()
			spawn_passing_right_to_left()

func spawn_passing_enemies_from_random_side():
	var r = randi() % 4
	match r:
		0:
			spawn_passing_top_to_bottom()
		1:
			spawn_passing_bottom_to_top()
		2:
			spawn_passing_top_to_bottom()
		3:
			spawn_passing_top_to_bottom()

func spawn_followers_from_random_side():
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_following_enemy_at(skinnyBoy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(skinnyBoy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(skinnyBoy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(skinnyBoy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(skinnyBoy, get_random_coord_at_random_side(screen_size))

func spawn_napkins_top_to_bottom():
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_passing_enemy_at(napkin, Vector2(quarter_screen, 0), Vector2(quarter_screen, screen_height+20))
	spawn_passing_enemy_at(napkin, Vector2(quarter_screen*2, 0) , Vector2(quarter_screen*2, screen_height+20))
	spawn_passing_enemy_at(napkin, Vector2(quarter_screen*3, 0) , Vector2(quarter_screen*3, screen_height+20))
	spawn_passing_enemy_at(napkin, Vector2(quarter_screen*4, 0) , Vector2(quarter_screen*4, screen_height+20))


func spawn_passing_top_to_bottom():
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_passing_enemy_at(fattyBoy, Vector2(quarter_screen, 0), Vector2(quarter_screen, screen_height+20))
	spawn_passing_enemy_at(fattyBoy, Vector2(quarter_screen*2, 0) , Vector2(quarter_screen*2, screen_height+20))
	spawn_passing_enemy_at(fattyBoy, Vector2(quarter_screen*3, 0) , Vector2(quarter_screen*3, screen_height+20))
	spawn_passing_enemy_at(fattyBoy, Vector2(quarter_screen*4, 0) , Vector2(quarter_screen*4, screen_height+20))

func spawn_passing_bottom_to_top():
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen, screen_height), Vector2(quarter_screen, -20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*2, screen_height) , Vector2(quarter_screen*2, -20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*3, screen_height) , Vector2(quarter_screen*3, -20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*4, screen_height) , Vector2(quarter_screen*4, -20))

func spawn_passing_left_to_right():
	var screen_width = screen_size.x
	var quarter_screen =  screen_size.y / 5
	spawn_passing_enemy_at(butterboy, Vector2(0, quarter_screen), Vector2(screen_width+20, quarter_screen))
	spawn_passing_enemy_at(butterboy, Vector2(0, quarter_screen*2) , Vector2(screen_width+20, quarter_screen*2))
	spawn_passing_enemy_at(butterboy, Vector2(0, quarter_screen*3) , Vector2(screen_width+20, quarter_screen*3))
	spawn_passing_enemy_at(butterboy, Vector2(0, quarter_screen*4) , Vector2(screen_width+20, quarter_screen*4))

func spawn_passing_right_to_left():
	var screen_width = screen_size.x
	var quarter_screen =  screen_size.y / 5
	spawn_passing_enemy_at(skinnyBoy, Vector2(screen_width, quarter_screen), Vector2(-20, quarter_screen))
	spawn_passing_enemy_at(skinnyBoy, Vector2(screen_width, quarter_screen*2), Vector2(-20, quarter_screen*2))
	spawn_passing_enemy_at(skinnyBoy, Vector2(screen_width, quarter_screen*3), Vector2(-20, quarter_screen*3))
	spawn_passing_enemy_at(skinnyBoy, Vector2(screen_width, quarter_screen*4), Vector2(-20, quarter_screen*4))


func _on_area_2d_area_entered(area):
	var enemy = area.get_parent()
	enemy.jump()

func _on_timer_timeout():
	_game_over()

func _on_player_died():
	_game_over()

func _on_player_hurt():
	_start_screen_shake(0.2, 2)

func _on_player_special_kick():
	_start_screen_shake(0.2, 4)
	
func _screen_shake(delta):
	if _shake_timer > 0:
		var offset = Vector2(randf_range(-_shake_amplitude, _shake_amplitude), randf_range(-_shake_amplitude, _shake_amplitude))
		camera2d.offset = offset
		_shake_timer -= delta
	else:
		camera2d.offset = _original_camera_position

func _start_screen_shake(duration, amplitude):
	_original_camera_position = camera2d.offset
	_shake_timer = duration
	_shake_amplitude = amplitude

func _count_napkins():
	for e in enemies_list:
		if e == null:
			enemies_list.erase(e)
		elif e.enemy_type == Enemy.TYPE.N:
			napkins.append(e)

func _clean_butter_below_napkins():
	for n in napkins:
		if n == null:
			napkins.erase(n)
		elif n.anim_state == Enemy.STATE.moving:
			_clean_butter(n.position)

func _clean_butter(pos):
	var tile = tile_map.local_to_map(pos)
	var x = tile.x
	var y = tile.y
	#This cleans 1 square at a time
	clean_tile_check(Vector2i(x, y))
	clean_tile_check(Vector2i(x+1, y))
	clean_tile_check(Vector2i(x, y+1))
	clean_tile_check(Vector2i(x-1, y))
	clean_tile_check(Vector2i(x, y-1))
	clean_tile_check(Vector2i(x+1, y-1))
	clean_tile_check(Vector2i(x+1, y+1))
	clean_tile_check(Vector2i(x-1, y+1))
	clean_tile_check(Vector2i(x-1, y-1))
