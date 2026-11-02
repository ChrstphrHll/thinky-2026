extends Resource

class_name Shape

var color: Color
var coords: Array[Vector2i]
var total_size: Vector2i
var current_position
var id 


func _init(
		color = Color(randf(), randf(), randf(), 1.0),
		coords: Array[Vector2i] = [
			Vector2i(0,0),
			Vector2i(0,1),
			Vector2i(1,0)
		],
		total_size = Vector2i(2,2),
		current_position = null
	):
	self.color = color
	self.coords = coords
	self.total_size = total_size
	self.current_position = current_position
	id = randf()


func debug():
	print("Color: ", color)
	print("coords: ", coords)
	print("total_size: ", total_size)
	print("current_position: ", current_position)
	print("id: ", id)



func rotate():
	pass
