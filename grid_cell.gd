extends ColorRect

@export var coord: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(coord)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
