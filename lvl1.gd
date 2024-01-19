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

func _on_left_area_2d_area_entered(area):
	var shape = $LeftArea2D/CollisionShape2D.shape
	var enemy = area.get_parent()
	enemy.jump(Vector2(shape.extents.x+30, 0))


func _on_top_area_2d_area_entered(area):
	var shape = $TopArea2D/CollisionShape2D.shape
	var enemy = area.get_parent()
	enemy.jump(Vector2(0, (shape.extents.y+30)))


func _on_bottom_area_2d_area_entered(area):
	var shape = $BottomArea2D/CollisionShape2D.shape
	var enemy = area.get_parent()
	enemy.jump(Vector2(0, -(shape.extents.y+30)))


func _on_right_area_2d_area_entered(area):
	var shape = $RightArea2D/CollisionShape2D.shape
	var enemy = area.get_parent()
	enemy.jump(Vector2(-(shape.extents.x+30), 0))
