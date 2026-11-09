extends Node

class_name ShapePuzzle

var grid = [
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
]

var overtime_enabled = false
var temp_hired = false


var pieces: Array[Shape] = [


	#Shape.new(),
	#Shape.new([Vector2i(0,0)], Vector2i(1,1)),
	#Shape.new( [
		#Vector2i(-1,0),
		#Vector2i(0,0),
		#Vector2i(1,0),
		#Vector2i(1,1),
	#], Vector2i(3,2)),
	#Shape.new( [
		#Vector2i(-1,0),
		#Vector2i(0,0),
		#Vector2i(1,0),
		#Vector2i(1,1),
	#], Vector2i(3,2)),
	#Shape.new([
		#Vector2i(-1,0),
		#Vector2i(0,0),
		#Vector2i(1,0),
	#], Vector2i(3,1))
]


func _init():
	load_pieces()


func create_board():
	pass


func load_pieces():
	var base_directory = "res://logic/pieces/"
	
	var pieces_raw = ResourceLoader.list_directory(base_directory)
	
	for piece_path in pieces_raw:
		var full_path = base_directory + piece_path
		var item = ResourceLoader.load(full_path)
		pieces.append(item)


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
	
	if row < 0:
		return false
	if overtime_enabled and row >= grid.size():
		return false
	if not overtime_enabled and row >= grid.size() - 4:
		return false

	var row_data = grid[row]

	if col < 0:
		return false
	if temp_hired and col >= row_data.size():
		return false
	if not temp_hired and col >= row_data.size() - 1:
		return false
	
	return true


func get_piece_from_id(id: float):
	var index = pieces.find_custom(func (piece): return piece.id == id)
	if index != -1:
		return pieces[index]
	return null


func remove_piece(piece_id: float):
	var piece: Shape = get_piece_from_id(piece_id)
	if piece.current_position == null:
		printerr("HEYYYYY!!!! you cant remove a piece that isn't placed")
		piece.debug()
		return
	for coord in piece.coords:
		var target_coord = piece.current_position + coord
		set_grid_value(target_coord,-1)
	piece.current_position = null


func add_piece(grid_coord: Vector2i, piece_id: float):
	var piece = get_piece_from_id(piece_id)
	piece.current_position = grid_coord
	for coord in piece.coords:
		var target_coord = grid_coord + coord
		set_grid_value(target_coord, 1)


func rotate_piece(piece_id: float):
	var piece = get_piece_from_id(piece_id)
	var new_coords: Array[Vector2i] = []
	for coord in piece.coords:
		new_coords.append(Vector2i(coord.y, coord.x * -1))
	piece.coords = new_coords


func get_grid_value(coord):
	return grid[coord.x][coord.y]


func set_grid_value(coord: Vector2i, value):
	grid[coord.x][coord.y] = value


func print_grid():
	for row in grid:
		print(row)
