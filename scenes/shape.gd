extends Control

@export var bounding_box: CanvasItem
@export var shape_data := Shape.new()
@export var shape_size := 50
@export var gap := 0

var dragging: bool = false
var drag_offset: Vector2
var total_node_size: Vector2

var placed := false

signal shape_dropped
signal removed_from_grid


# Called when the node enters the scene tree for the first time.
func _ready():
	print(shape_data.id)
	total_node_size = shape_data.total_size * shape_size
	for coord in shape_data.coords:
		var box = ColorRect.new()
		box.color = shape_data.color
		box.size = Vector2i(shape_size, shape_size)
		box.position = shape_size * Vector2i(coord.y, coord.x) + gap * coord
		box.mouse_filter = Control.MOUSE_FILTER_PASS
		add_child(box)
	
	#var origin = ColorRect.new()
	#origin.size = Vector2(5,5)
	#origin.position = Vector2(shape_size / 2.0 - 2.5, shape_size / 2.0 - 2.5)
	#add_child(origin)
	
	#var label = Label.new()
	#label.text = str(shape_data.id)
	#add_child(label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		var raw_position = get_global_mouse_position() - drag_offset
		var min_clamp = Vector2(bounding_box.global_position.x, bounding_box.global_position.y)
		global_position = raw_position.clamp(min_clamp, bounding_box.global_position + bounding_box.size - total_node_size)


func _on_gui_input(event: InputEvent):
	# TODO: dont call this on every click for active window
	if event is InputEventMouseButton and event.is_pressed():
		drag()

	elif event is InputEventMouseButton and event.is_released():
		drop()


func drag():
	drag_offset = get_local_mouse_position()
	dragging = true
	move_to_front.call_deferred()
	
	if placed:
		placed = false
		removed_from_grid.emit(shape_data.id)


func drop():
	dragging = false
	var origin_position = get_origin_position()
	shape_dropped.emit(self, origin_position)


func get_origin_position():
	return global_position + Vector2(shape_size / 2.0, shape_size / 2.0)


func get_piece_coord_from_mouse():
	var mouse_pos = get_local_mouse_position()
	var normalized = mouse_pos / shape_size
	return normalized.floor()
