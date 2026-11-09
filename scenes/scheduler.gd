extends Control

var temp_hired = false
var overtime_enabled = false

const GRID_CELL = preload("uid://ctckwyr7p00bo")
const SHAPE = preload("uid://c11v2d7y4jqro")
const SHAPE_SIZE = 55

var puzzle = ShapePuzzle.new()

@onready var grid_container = $HBoxContainer/CenterContainer/GridContainer
@onready var piece_anchors = [
	$HBoxContainer/Tray/Point, $HBoxContainer/Tray/Point2, $HBoxContainer/Tray/Point3, $HBoxContainer/Tray/Point4, $HBoxContainer/Tray/Point5, $HBoxContainer/Tray/Point6, $HBoxContainer/Tray/Point7, $HBoxContainer/Tray/Point8, $HBoxContainer/Tray/Point9, $HBoxContainer/Tray/Point10, $HBoxContainer/Tray/Point11, $HBoxContainer/Tray/Point12, $HBoxContainer/Tray/Point13, $HBoxContainer/Tray/Point14, $HBoxContainer/Tray/Point15, $HBoxContainer/Tray/Point16, $HBoxContainer/Tray/Point17, $HBoxContainer/Tray/Point18, $HBoxContainer/Tray/Point19, $HBoxContainer/Tray/Point20, $HBoxContainer/Tray/Point21, $HBoxContainer/Tray/Point22, $HBoxContainer/Tray/Point23, $HBoxContainer/Tray/Point24, $HBoxContainer/Tray/Point25
]


func _ready():
	Signals.temp_hired.connect(hire_temp)
	Signals.overtime_enabled.connect(enable_overtime)
	Signals.day_started.connect(check_full_board)
	
	for shape in puzzle.pieces:
		var instance = SHAPE.instantiate()
		instance.bounding_box = self
		instance.shape_data = shape
		instance.shape_size = SHAPE_SIZE
		instance.position = get_shape_starting_position(instance)
		
		instance.shape_dropped.connect(_on_shape_dropped)
		instance.removed_from_grid.connect(_on_shape_removed_from_grid)
		instance.shape_rotated.connect(_on_shape_rotated)
		add_child(instance)
	
	grid_container.columns = puzzle.grid[0].size()
	var time = 7
	for row_i in puzzle.grid.size():
		var overtime_group = row_i > 8
		var time_label = Label.new()
		time_label.text = str(time) + ":00"
		time += 1
		if time == 13:
			time = 1
		grid_container.add_child(time_label)
		if overtime_group:
			time_label.add_to_group("overtime")
			time_label.hide()
		for col_i in puzzle.grid[0].size():
			var temp_group = col_i == puzzle.grid[0].size() - 1
				
			var instance = GRID_CELL.instantiate()
			instance.coord = Vector2i(row_i, col_i)
			instance.grid_size = SHAPE_SIZE
			grid_container.add_child(instance)
			instance.add_to_group("grid_cells")
			if overtime_group and temp_group:
				instance.add_to_group("temp_and_overtime")
			elif overtime_group:
				instance.add_to_group("overtime")
			elif temp_group:
				instance.add_to_group("temp")
			
			if overtime_group or temp_group:
				instance.hide()


func enable_overtime():
	var overtime_nodes = get_overtime_nodes()
	for node in overtime_nodes:
		node.show()
	puzzle.overtime_enabled = true
	overtime_enabled = true


func hire_temp():
	var temp_nodes = get_temp_nodes()
	for node in temp_nodes:
		node.show()
	puzzle.temp_hired = true
	temp_hired = true
	grid_container.columns = puzzle.grid[0].size() + 1


func get_overtime_nodes():
	var all_nodes = []
	all_nodes.append_array(get_tree().get_nodes_in_group("overtime"))
	if temp_hired:
		all_nodes.append_array(get_tree().get_nodes_in_group("temp_and_overtime"))
	
	return all_nodes


func get_temp_nodes():
	var all_nodes = []
	all_nodes.append_array(get_tree().get_nodes_in_group("temp"))
	if overtime_enabled:
		all_nodes.append_array(get_tree().get_nodes_in_group("temp_and_overtime"))
	
	return all_nodes


func get_shape_starting_position(shape_node):
	#var rect = $HBoxContainer/Tray.size
	#print("rect", rect)
	#var x = randf_range(0, rect.x)
	#var y = randf_range(0, rect.y)
	var anchor = piece_anchors.pop_front()
	if not anchor:
		return Vector2(50, 50)
	return anchor.position


func _on_shape_dropped(shape_node: Control, mouse_position: Vector2):
	var grid_cell = get_grid_cell_data(mouse_position)
	if not grid_cell:
		return
	
	print("trying to place here ", grid_cell)
	var valid = puzzle.check_piece_valid_placement(shape_node.shape_data, grid_cell.coord)
	
	if valid:
		puzzle.add_piece(grid_cell.coord, shape_node.shape_data.id)
		place_piece(shape_node, grid_cell.position)
	else:
		bounce_piece()
	print("is valid ", valid)
	
	print("is board full? ", check_full_board())


func _on_shape_removed_from_grid(piece_id: float):
	puzzle.remove_piece(piece_id)


func _on_shape_rotated(piece_id: float, shape_node):
	puzzle.remove_piece(piece_id)
	puzzle.rotate_piece(piece_id)
	shape_node.post_rotation_check()


func place_piece(shape_node: Control, grid_cell_position: Vector2):
	shape_node.place_at_grid(grid_cell_position)
	shape_node.placed = true


func bounce_piece():
	pass


func get_grid_cell_data(mouse_position: Vector2):
	var cells: Array[Node] = get_tree().get_nodes_in_group("grid_cells")
	for slot in cells:
		if not slot.visible:
			continue
		var rect = slot.get_global_rect()
		if rect.has_point(mouse_position):
			print(rect.position)
			return {
				"position": rect.position,
				"coord": slot.coord
			}
	return


func check_full_board():
	for piece in puzzle.pieces:
		if piece.current_position == null:
			return false
	Signals.game_won.emit()
	return true
