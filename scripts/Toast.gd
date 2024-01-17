extends TileMap

var toast_matrix : Array

var used_tiles: Array[Vector2i]
var min_x : int
var max_x : int
var min_y : int
var max_y : int

var width : int
var height : int

# Called when the node enters the scene tree for the first time.
func _ready():
	used_tiles = self.get_used_cells(0)
	min_x = used_tiles[0].x
	max_x = used_tiles[0].x
	min_y = used_tiles[0].y
	max_y = used_tiles[0].y
	for vector in used_tiles:
		if vector.x < min_x:
			min_x = vector.x
		elif vector.x > max_x:
			max_x = vector.x
		if vector.y < min_y:
			min_y = vector.y
		elif vector.y > max_y:
			max_y = vector.y
	
	width = max_x - min_x + 1
	height = max_y - min_y + 1
	for x in range(width):
		var column: Array = []
		for y in range(height):
			column.append(0)
		toast_matrix.append(column)


func draw_cross(x, y, v):
	print("Hi")
	var vector: Array[Vector2i]
	vector.append(Vector2i(x-1, y))
	vector.append(Vector2i(x, y))
	vector.append(Vector2i(x+1, y))
	vector.append(Vector2i(x, y+1))
	vector.append(Vector2i(x, y-1))
	self.set_cells_terrain_connect(0, vector, 0, 0, true)
