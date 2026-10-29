extends Control

@export var bounding_box: CanvasItem


var dragging: bool = false
var drag_offset: Vector2

var resizing: bool = false
var resizing_origin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		var raw_position = get_global_mouse_position() - drag_offset
		global_position = raw_position.clamp(bounding_box.global_position, bounding_box.global_position + bounding_box.size - self.size)

func _on_top_bar_button_down():
	dragging = true
	drag_offset = get_local_mouse_position()
	print(drag_offset)


func _on_top_bar_button_up():
	dragging = false


func _on_resize_button_down(corner_index: int):
	print("resizing from ", corner_index)


func _on_close_pressed():
	self.queue_free()
