extends Node2D

var _tile_map: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	_tile_map = $TileMap
	# Habilitar el manejo de la entrada del teclado
	set_process_input(true)
