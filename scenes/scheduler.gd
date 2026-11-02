extends Control

@onready var shape = $Shape

const GRID_CELL = preload("uid://ctckwyr7p00bo")
const SHAPE = preload("uid://c11v2d7y4jqro")
const SHAPE_SIZE = 50
@onready var grid_container = $ColorRect2/MarginContainer/GridContainer

var puzzle = ShapePuzzle.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var test = ShapePuzzle.new()
	for shape in puzzle.pieces:
		var instance = SHAPE.instantiate()
		instance.bounding_box = self
		instance.shape_data = shape
		instance.shape_size = SHAPE_SIZE
		
		instance.shape_dropped.connect(_on_shape_dropped)
		instance.removed_from_grid.connect(_on_shape_removed_from_grid)
		add_child(instance)
	
	grid_container.columns = puzzle.grid[0].size()
	
	for row_i in puzzle.grid.size():
		for col_i in puzzle.grid[0].size():
			var instance = GRID_CELL.instantiate()
			instance.coord = Vector2i(row_i, col_i)
			grid_container.add_child(instance)
			instance.add_to_group("grid_cells")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_shape_dropped(shape_node: Control, mouse_position: Vector2):
	var grid_cell = get_grid_cell_data(mouse_position)
	if not grid_cell:
		return
	
	var valid = puzzle.check_piece_valid_placement(shape_node.shape_data, grid_cell.coord)
	
	if valid:
		puzzle.add_piece(grid_cell.coord, shape_node.shape_data.id)
		place_piece(shape_node, grid_cell.position)
	else:
		bounce_piece()
	print("is valid ", valid)


func _on_shape_removed_from_grid(piece_id: float):
	puzzle.remove_piece(piece_id)


func place_piece(shape_node: Control, grid_cell_position: Vector2):
	shape_node.global_position = grid_cell_position
	shape_node.placed = true


func bounce_piece():
	pass


func get_grid_cell_data(mouse_position: Vector2):
	print("looking for grid cell")
	for slot in get_tree().get_nodes_in_group("grid_cells"):
		var rect = slot.get_global_rect()
		if rect.has_point(mouse_position):
			print(rect.position)
			return {
				"position": rect.position,
				"coord": slot.coord
			}
			
	return
