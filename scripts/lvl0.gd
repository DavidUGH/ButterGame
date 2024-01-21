extends Level

var _enemy_spawn_flag = false
var butterboy = preload("res://butterboy.tscn")

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

func _process(delta):
	if(Input.is_key_pressed(KEY_F)):
		if(!_enemy_spawn_flag):
			_enemy_spawn_flag = true
			spawn_enemy(butterboy)
	else:
		_enemy_spawn_flag = false


func _on_area_2d_area_entered(area):
	var enemy = area.get_parent()
	enemy.jump()
