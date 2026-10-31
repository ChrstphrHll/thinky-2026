extends Control

@export var bounding_box: CanvasItem
@export var window_name := "Name"
@export var contents: PackedScene

var dragging: bool = false
var drag_offset: Vector2

var resizing: bool = false
var resizing_origin

static var highest_z_index = 0

@onready var v_box_container = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	if contents:
		var instance = contents.instantiate()
		v_box_container.add_child(instance)
	
	_set_z_index()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		var raw_position = get_global_mouse_position() - drag_offset
		var self_offset = self.size * 0.2
		var min_clamp = Vector2(bounding_box.global_position.x - self.size.x * 0.8, bounding_box.global_position.y)
		global_position = raw_position.clamp(min_clamp, bounding_box.global_position + bounding_box.size - self_offset)


func _set_z_index():
	highest_z_index += 1
	z_index = highest_z_index

func _on_top_bar_button_down():
	dragging = true
	drag_offset = get_local_mouse_position()
	print(drag_offset)


func _on_top_bar_button_up():
	dragging = false


func _on_resize_button_down(corner_index: int):
	print("resizing from ", corner_index)


func _on_close_pressed():
	self.hide()


func _on_focus_detector_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		_set_z_index()
