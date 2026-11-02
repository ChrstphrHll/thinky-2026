extends Resource

class_name Shape

var color: Color
var coords: Array[Vector2i]
var total_size: Vector2i
var current_position
var id 


func _init(
		coords: Array[Vector2i] = [
			Vector2i(0,0),
			Vector2i(0,1),
			Vector2i(1,0)
		],
		total_size = Vector2i(2,2),
		color = Color(randf(), randf(), randf(), 1.0),
	):
	self.color = color
	self.coords = coords
	self.total_size = total_size
	self.current_position = null
	id = randf()


func debug():
	print("Color: ", color)
	print("coords: ", coords)
	print("total_size: ", total_size)
	print("current_position: ", current_position)
	print("id: ", id)



func rotate():
	pass
