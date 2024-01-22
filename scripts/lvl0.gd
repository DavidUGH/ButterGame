extends Level

var spawn_flag = true
var butterboy = preload("res://butterboy.tscn")
var screen_size

func _ready():
	for i in range(filas):
		var fila: Array = []
		for j in range(columnas):
			fila.append(0)
		butter_matrix.append(fila)
	player = $Player
	tile_map = $TileMap
	GUI = $GUI
	player.gui = GUI
	screen_size = get_viewport().content_scale_size

func spawn_enemies_periodically():
	if spawn_flag:
		random_spawn_pattern()
		spawn_flag = false
		await get_tree().create_timer(3).timeout
		spawn_flag = true

func random_spawn_pattern():
	var r = randi() % 5
	match r:
		0:
			spawn_pattern_left_to_right()
		1:
			spawn_pattern_right_to_left()
		2:
			spawn_pattern_top_to_bottom()
		3:
			spawn_pattern_bottom_to_top()
		_:
			spawn_followers_from_random_side()

func spawn_followers_from_random_side():
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_following_enemy_at(butterboy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(butterboy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(butterboy, get_random_coord_at_random_side(screen_size))
	spawn_following_enemy_at(butterboy, get_random_coord_at_random_side(screen_size))

func spawn_pattern_top_to_bottom():
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen, 0), Vector2(quarter_screen, screen_height+20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*2, 0) , Vector2(quarter_screen*2, screen_height+20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*3, 0) , Vector2(quarter_screen*3, screen_height+20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*4, 0) , Vector2(quarter_screen*4, screen_height+20))

func spawn_pattern_bottom_to_top():
	var screen_height = screen_size.y
	var quarter_screen =  screen_size.y / 4
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen, screen_height), Vector2(quarter_screen, -20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*2, screen_height) , Vector2(quarter_screen*2, -20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*3, screen_height) , Vector2(quarter_screen*3, -20))
	spawn_passing_enemy_at(butterboy, Vector2(quarter_screen*4, screen_height) , Vector2(quarter_screen*4, -20))

func spawn_pattern_left_to_right():
	var screen_width = screen_size.x
	var quarter_screen =  screen_size.y / 5
	spawn_passing_enemy_at(butterboy, Vector2(0, quarter_screen), Vector2(screen_width+20, quarter_screen))
	spawn_passing_enemy_at(butterboy, Vector2(0, quarter_screen*2) , Vector2(screen_width+20, quarter_screen*2))
	spawn_passing_enemy_at(butterboy, Vector2(0, quarter_screen*3) , Vector2(screen_width+20, quarter_screen*3))
	spawn_passing_enemy_at(butterboy, Vector2(0, quarter_screen*4) , Vector2(screen_width+20, quarter_screen*4))

func spawn_pattern_right_to_left():
	var screen_width = screen_size.x
	var quarter_screen =  screen_size.y / 5
	spawn_passing_enemy_at(butterboy, Vector2(screen_width, quarter_screen), Vector2(-20, quarter_screen))
	spawn_passing_enemy_at(butterboy, Vector2(screen_width, quarter_screen*2), Vector2(-20, quarter_screen*2))
	spawn_passing_enemy_at(butterboy, Vector2(screen_width, quarter_screen*3), Vector2(-20, quarter_screen*3))
	spawn_passing_enemy_at(butterboy, Vector2(screen_width, quarter_screen*4), Vector2(-20, quarter_screen*4))

func _process(delta):
	spawn_enemies_periodically()


func _on_area_2d_area_entered(area):
	var enemy = area.get_parent()
	enemy.jump()
