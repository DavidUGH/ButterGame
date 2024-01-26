extends Sprite2D

enum TYPE {Damage, AS, MS}
var stat_type : TYPE
var stat = 0

func set_type(type_stat):
	stat = type_stat
	var light : PointLight2D
	light = $PointLight2D
	match stat:
		0:
			modulate = Color.DARK_RED
			light.color = Color.DARK_RED
			stat_type = TYPE.Damage
		1:
			modulate = Color.GREEN
			light.color = Color.GREEN
			stat_type = TYPE.AS
		2:
			modulate = Color.AQUA
			light.color = Color.AQUA
			stat_type = TYPE.MS
		_:
			print("This shouldn't happen")

func pick_up():
	match stat:
		0:
			return 1.0
		1:
			return 0.1
		2:
			return 10
