extends Level

var _enemy_spawn_flag = false
var butterboy = preload("res://butterboy.tscn")

func _ready():
	player = $Player
	tile_map = $TileMap
	tiles_to_win = 144

func _process(delta):
	spawn_following_enemy_at(butterboy, get_random_coord_at_random_side(get_viewport().content_scale_size))

func _on_area_2d_area_entered(area):
	var enemy = area.get_parent()
	enemy.jump()
