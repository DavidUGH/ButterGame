extends Node2D

var enemy_scen = preload("res://butterboy.tscn")
var player_instance

var flag : bool = false

var enemies_list: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player_instance = $"../Player"
	# Habilitar el manejo de la entrada del teclado
	set_process_input(true)

# Función llamada cada fotograma para manejar la entrada del teclado
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
	nueva_instancia.player = player_instance
	nueva_instancia.position = Vector2(randf_range(0, 1280), randf_range(0, 720))
	add_child(nueva_instancia)

	# Agregar la nueva instancia a la lista de enemigos
	enemies_list.append(nueva_instancia)
