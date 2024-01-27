class_name  Finals
extends Control

static var percentage :int  = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("BUTTER PERCENTAGE: "+str(percentage))
	if(percentage<30):
		$BadEnding.visible = true
	if(percentage>30 && percentage <85):
		$NormalEnding.visible = true
	if(percentage>85):
		$PerfectEnding.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
