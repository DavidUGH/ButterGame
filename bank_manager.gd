extends StudioBankLoader

var volume : float

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_music_volume(0.7)
	set_sfx_volume(0.7)

func get_music_volume():
	var v = FMODStudioModule.get_studio_system().get_parameter_by_name("musicVolume").value
	return ceil(v * 10) / 10

func get_sfx_volume():
	var v = FMODStudioModule.get_studio_system().get_parameter_by_name("effectsVolume").value
	return ceil(v * 10) / 10

func set_music_volume(v):
	print("Hi")
	FMODStudioModule.get_studio_system().set_parameter_by_name("musicVolume", v)

func set_sfx_volume(v):
	FMODStudioModule.get_studio_system().set_parameter_by_name("effectsVolume", v)
