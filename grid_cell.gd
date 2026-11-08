extends ColorRect

@export var coord: Vector2i
@export var grid_size = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(coord)
	custom_minimum_size = Vector2(grid_size, grid_size)
