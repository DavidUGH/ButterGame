extends Control

signal vida_cambiada(vida_actual)

var life_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	life_label = $LifeLabel
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_vida_cambiada(vida_actual):
	life_label.text = "Life: " + vida_actual
