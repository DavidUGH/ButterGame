extends Node

var enemy_scen = preload("res://butterboy.tscn")
var enemies_list: Array = []
var player
var flag:bool = false

var tile_map : TileMap

func _ready():
	player = $Player
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	tile_map = $TileMap2
	
func _process(delta):
	if(Input.is_key_pressed(KEY_F)):
		if(!flag):
			flag = true
			spawn_enemy()
	else:
		flag = false

# Función para realizar el spawn de una instancia de enemigo
func spawn_enemy():
	var nueva_instancia: = enemy_scen.instantiate()
	print(player)
	nueva_instancia.player = player
	nueva_instancia.tile_map = tile_map
	nueva_instancia.position = Vector2(randf_range(0, 1280), randf_range(0, 720))
	add_child(nueva_instancia)

	# Agregar la nueva instancia a la lista de enemigos
	enemies_list.append(nueva_instancia)
