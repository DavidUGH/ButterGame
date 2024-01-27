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
var possible_waves = [-1]
var napkin_flag = false

var last_wave = 0

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
	GUI.lifeBar.max_value = player.life
	GUI.lifeBar.value = player.life
	camera2d = $Camera2D
	time_counter = 4.0
	screen_size = get_viewport().content_scale_size

func _process(delta):
	_set_level()
	spawn_enemies_periodically()
	_screen_shake(delta)
	_count_napkins()
	_clean_butter_below_napkins()
	var minutes = floor(timer.time_left / 60)
	var seconds = floor(timer.time_left - minutes * 60)
	GUI.setConsole(str(minutes) + ":" + time_format(seconds))
	spawn_napkin()

func spawn_napkin():
	if !napkin_flag:
		var set = []
		if GUI.butterBar.value >= 70:
			set = [9, 10] # multiple vertical or horizontal
		elif GUI.butterBar.value >= 50:
			set = [5, 6, 7, 8] # singular vertical or horizontal
		else:
			return
		var random_index = randi() % set.size()
		queue.push_front(set[random_index])
		napkin_flag = true
		await get_tree().create_timer(6).timeout
		napkin_flag = false


var cursed_flag = 0

func _set_level():
	var t = floor(timer.time_left)
	#print(t)
	if t == 160 and cursed_flag == 0: # 180 - 161
		possible_waves.pop_front() # remove line skinny bitch
		possible_waves.append(0)
		possible_waves.append(1) # add random side butterboy
		cursed_flag = 1
	elif t == 140: # 160 - 131
		time_counter = 3
	elif t == 120 and cursed_flag == 1: # 130 - 120
		cursed_flag = 2
		possible_waves.append(2) # add cross waves v
		possible_waves.append(3) # add cross waves h
	elif t == 100:
		time_counter = 2.5
	elif t == 80 and cursed_flag == 2:
		cursed_flag = 3
		possible_waves.append(4) # add fatty
	elif t == 60:
		time_counter = 2
	elif t == 40 and cursed_flag == 3:
		cursed_flag = 4
	elif t == 20:
		time_counter = 1

func time_format(time):
	if time < 10:
		return "0" + str(time)
	return str(time)

func spawn_enemies_periodically():
	if spawn_flag:
		var random_index = 0
		if possible_waves.size() > 1:
			random_index = randi() % possible_waves.size()
			while possible_waves[random_index] == last_wave:
				random_index = randi() % possible_waves.size()
		last_wave = possible_waves[random_index]
		queue.push_back(possible_waves[random_index])
		print(possible_waves)
		#print(queue)
		var next = queue.pop_front()
		spawn_wave(next)
		spawn_flag = false
		await get_tree().create_timer(time_counter).timeout
		spawn_flag = true

func spawn_wave(next):
	match next:
		-1:
			spawn_one_follower(skinnyBoy)
		0: # followers at random
			spawn_followers_from_random_side(skinnyBoy)
		1: # passing random side
			spawn_passing_enemies_from_random_side(butterboy)
		2: # passing cross top and bottom
			spawn_passing_enemies_cross(butterboy, 0)
		3: # passing cross left and right
			spawn_passing_enemies_cross(butterboy, 1)
		4: # spawn follower fatty
			spawn_one_follower(fattyBoy)
		5: # passing napkin top to bottom
			spawn_lone_top_to_bottom(napkin)
		6: # passing napkin left to right
			spawn_lone_left_to_right(napkin)
		7: # passing napkin left to right
			spawn_lone_bottom_to_top(napkin)
		8:
			spawn_lone_right_to_left(napkin)
		9: # 4 passing napkins top to bottom
			spawn_passing_top_to_bottom(napkin)
		10: # 4 passing napkins left to right
			spawn_passing_left_to_right(napkin)


func spawn_lone_left_to_right(enemy):
	var screen_width = screen_size.x
	var half_screen =  screen_size.x / 2
	spawn_passing_enemy_at(enemy, Vector2(0, half_screen) , Vector2(screen_width+20, half_screen))

func spawn_lone_top_to_bottom(enemy):
	var screen_height = screen_size.y
	var half_screen =  screen_size.y / 2
	spawn_passing_enemy_at(enemy, Vector2(half_screen, 0), Vector2(half_screen, screen_height+20))

func spawn_lone_right_to_left(enemy):
	var screen_width = screen_size.x
	var half_screen =  screen_size.x / 2
	spawn_passing_enemy_at(enemy, Vector2(screen_width, half_screen), Vector2(-20, half_screen))

func spawn_lone_bottom_to_top(enemy):
	var screen_height = screen_size.y
	var half_screen =  screen_size.y / 2
	spawn_passing_enemy_at(enemy, Vector2(half_screen, screen_height) , Vector2(half_screen, -20))

func spawn_passing_enemies_cross(enemy, side):
	match side:
		0: # vertical
			spawn_passing_top_to_bottom(enemy)
			spawn_passing_bottom_to_top(enemy)
		1: # horizontal
			spawn_passing_left_to_right(enemy)
			spawn_passing_right_to_left(enemy)

func spawn_passing_enemies_from_random_side(enemy):
	var r = randi() % 4
	match r:
		0:
			spawn_passing_top_to_bottom(enemy)
		1:
			spawn_passing_bottom_to_top(enemy)
		2:
			spawn_passing_top_to_bottom(enemy)
		3:
			spawn_passing_top_to_bottom(enemy)

func spawn_one_follower(enemy):
	spawn_following_enemy_at(enemy, get_random_coord_at_random_side(screen_size))

func spawn_followers_from_random_side(enemy):
	spawn_following_enemy_at(enemy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(enemy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(enemy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(enemy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(enemy, get_random_coord_at_random_side(screen_size))

func spawn_passing_top_to_bottom(enemy):
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_passing_enemy_at(enemy, Vector2(quarter_screen, 0), Vector2(quarter_screen, screen_height+20))
	spawn_passing_enemy_at(enemy, Vector2(quarter_screen*2, 0) , Vector2(quarter_screen*2, screen_height+20))
	spawn_passing_enemy_at(enemy, Vector2(quarter_screen*3, 0) , Vector2(quarter_screen*3, screen_height+20))
	spawn_passing_enemy_at(enemy, Vector2(quarter_screen*4, 0) , Vector2(quarter_screen*4, screen_height+20))

func spawn_passing_bottom_to_top(enemy):
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_passing_enemy_at(enemy, Vector2(quarter_screen, screen_height), Vector2(quarter_screen, -20))
	spawn_passing_enemy_at(enemy, Vector2(quarter_screen*2, screen_height) , Vector2(quarter_screen*2, -20))
	spawn_passing_enemy_at(enemy, Vector2(quarter_screen*3, screen_height) , Vector2(quarter_screen*3, -20))
	spawn_passing_enemy_at(enemy, Vector2(quarter_screen*4, screen_height) , Vector2(quarter_screen*4, -20))

func spawn_passing_left_to_right(enemy):
	var screen_width = screen_size.x
	var quarter_screen =  screen_size.y / 5
	spawn_passing_enemy_at(enemy, Vector2(0, quarter_screen), Vector2(screen_width+20, quarter_screen))
	spawn_passing_enemy_at(enemy, Vector2(0, quarter_screen*2) , Vector2(screen_width+20, quarter_screen*2))
	spawn_passing_enemy_at(enemy, Vector2(0, quarter_screen*3) , Vector2(screen_width+20, quarter_screen*3))
	spawn_passing_enemy_at(enemy, Vector2(0, quarter_screen*4) , Vector2(screen_width+20, quarter_screen*4))

func spawn_passing_right_to_left(enemy):
	var screen_width = screen_size.x
	var quarter_screen =  screen_size.y / 5
	spawn_passing_enemy_at(enemy, Vector2(screen_width, quarter_screen), Vector2(-20, quarter_screen))
	spawn_passing_enemy_at(enemy, Vector2(screen_width, quarter_screen*2), Vector2(-20, quarter_screen*2))
	spawn_passing_enemy_at(enemy, Vector2(screen_width, quarter_screen*3), Vector2(-20, quarter_screen*3))
	spawn_passing_enemy_at(enemy, Vector2(screen_width, quarter_screen*4), Vector2(-20, quarter_screen*4))


func _on_area_2d_area_entered(area):
	var enemy = area.get_parent()
	enemy.jump()

func _on_timer_timeout():
	_game_over(true)

func _on_player_died():
	_game_over(false)

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
