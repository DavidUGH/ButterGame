extends MultiMeshInstance2D
	
func _draw():
	var center = Vector2(200, 200)
	var radius = 80
	var color = Color(1.0, 0.0, 0.0)
	var arr: PackedVector2Array
	arr.append(Vector2(200, 200))
	arr.append(Vector2(200, 201))
	arr.append(Vector2(202, 202))
	arr.append(Vector2(203, 203))
	draw_colored_polygon(arr, color)
