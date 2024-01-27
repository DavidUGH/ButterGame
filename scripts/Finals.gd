class_name  Finals
extends Control

static var percentage :int  = 3

var music : StudioEventEmitter2D

# Called when the node enters the scene tree for the first time.
func _ready():
	music = $StudioEventEmitter2D
	print("BUTTER PERCENTAGE: "+str(percentage))
	if(percentage<30):
		music.parameter_musicState = 2
		$BadEnding.visible = true
	if(percentage>30 && percentage <85):
		$NormalEnding.visible = true
		music.parameter_musicState = 3
	if(percentage>85):
		$PerfectEnding.visible = true
		music.parameter_musicState = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
