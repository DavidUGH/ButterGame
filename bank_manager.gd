extends StudioBankLoader

var volume : float

func _ready():
	change_music_volume(1)
	change_effects_volume(0.7)

func change_music_volume(v):
	FMODStudioModule.get_studio_system().set_parameter_by_name("musicVolume", v)

func change_effects_volume(v):
	FMODStudioModule.get_studio_system().set_parameter_by_name("effectsVolume", v)
