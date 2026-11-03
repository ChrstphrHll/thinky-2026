extends Node

class_name ShapePuzzle

var grid = [
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
]

var pieces: Array[Shape] = [
	ResourceLoader.load("res://logic/pieces/4-square.tres"),
	ResourceLoader.load("res://logic/pieces/4-z.tres"),
	Shape.new(),
	Shape.new([Vector2i(0,0)], Vector2i(1,1)),
	Shape.new( [
		Vector2i(-1,0),
		Vector2i(0,0),
		Vector2i(1,0),
		Vector2i(1,1),
	], Vector2i(3,2)),
	Shape.new( [
		Vector2i(-1,0),
		Vector2i(0,0),
		Vector2i(1,0),
		Vector2i(1,1),
	], Vector2i(3,2)),
	Shape.new([
		Vector2i(-1,0),
		Vector2i(0,0),
		Vector2i(1,0),
	], Vector2i(3,1))
]


func _init():
	pass


func create_board():
	pass


func load_pieces():
	pass


func check_piece_valid_placement(piece, grid_coord):
	for coord in piece.coords:
		if not _check_piece_part_valid_placement(piece, coord, grid_coord):
			return false
	return true


func _check_piece_part_valid_placement(piece, piece_coord: Vector2i, grid_coord: Vector2i):
	var target_grid_coord = grid_coord + piece_coord
	if not _is_coord_in_grid(target_grid_coord):
		return false
	if not _is_grid_space_available(piece, target_grid_coord):
		return false
	return true


func _is_grid_space_available(piece, target_grid_coord: Vector2i):
	var current_grid_value = get_grid_value(target_grid_coord)
	if current_grid_value == -1:
		return true
	return false


func _is_coord_in_grid(target_grid_coord: Vector2i):
	var row = target_grid_coord.x
	var col = target_grid_coord.y
		
	if row < 0 or row >= grid.size():
		return false

	var row_data = grid[row]

	if col < 0 or col >= row_data.size():
		return false
	
	return true


func get_piece_from_id(id: float):
	print("looking for", id)
	for piece in pieces:
		print("id ", piece.id)
	var index = pieces.find_custom(func (piece): return piece.id == id)
	print("fount it at ", index)
	if index != -1:
		return pieces[index]
	return null


func remove_piece(piece_id: float):
	var piece = get_piece_from_id(piece_id)
	for coord in piece.coords:
		var target_coord = piece.current_position + coord
		set_grid_value(target_coord,-1)
	piece.current_position = null
	
	print_grid()


func add_piece(grid_coord: Vector2i, piece_id: float):
	var piece = get_piece_from_id(piece_id)
	piece.debug()
	piece.current_position = grid_coord
	for coord in piece.coords:
		var target_coord = grid_coord + coord
		set_grid_value(target_coord, 1)

	print_grid()

func rotate_piece():
	pass


func get_grid_value(coord):
	return grid[coord.x][coord.y]


func set_grid_value(coord: Vector2i, value):
	grid[coord.x][coord.y] = value


func print_grid():
	for row in grid:
		print(row)
