extends Control

signal vida_cambiada(vida_actual)

var life_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	life_label = $LifeLabel

func set_life(life):
	life_label.text = "Life: " + str(life)
