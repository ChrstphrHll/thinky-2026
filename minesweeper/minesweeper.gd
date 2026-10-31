extends Control

var board: Array[Array] = []

# Game Settings
var board_bombs = 20
var board_rows = 15
var board_cols = 15
var target_reveals = board_rows * board_cols - board_bombs
var revealed = 0

const BUTTON_SIZE = 18
const FONT_SIZE = 12
const BOMB_SYMBOL = "🐄"
const FLAGGED = "🛸"
const BLANK = "   "
const ADJACENT_DELTAS = [
	[-1, -1], [-1,  0], [-1 ,  1],
	[ 0, -1],           [ 0 ,  1],
	[ 1, -1], [ 1,  0], [ 1 ,  1],
]

@onready var win_label = $Label
@onready var board_ui = $CenterContainer/Board

const CELL_BUTTON = preload("uid://bcqe48ggyfioa")
const CELL_BUTTON_DISABLED = preload("uid://ds05seb1vtjit")
const CELL_BUTTON_HOVER = preload("uid://b0sex4lta7p8h")

signal win_game

# Called when the node enters the scene tree for the first time.
func _ready():
	create_board()
	win_game.connect(_win_effects)


func reset():
	pass

func game_over():
	pass


func _win_effects():
	print("you win!!!")
	win_label.show()


func _button_pressed(coords):
	var button = get_button(coords)
	var cell_value = button.text
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if cell_value == FLAGGED:
			button.text = BLANK
		else:
			button.text = FLAGGED
	elif cell_value == FLAGGED:
		pass
	else:
		set_revealed(coords, true)

		if is_coord_bomb(coords):
			game_over()
		else:
			if get_coord(coords) == 0:
				zero_cascade(coords)


func zero_cascade(coord):
	var next_zeroes = [coord]
	
	while next_zeroes:
		var this_zero = next_zeroes.pop_front()
		var adjacent_unrevealed = get_unrevealed_adjacent_cells(this_zero)
		
		for unrevealed in adjacent_unrevealed:
			set_revealed(unrevealed, true)
			if get_coord(unrevealed) == 0:
				next_zeroes.append(unrevealed)


func get_unrevealed_adjacent_cells(coord):
	var results = []
	
	for mod in ADJACENT_DELTAS:
		var neighbor = {
			"row": coord.row + mod[0],
			"col": coord.col + mod[1]
		}
		
		if not is_coord_inbounds(neighbor):
			continue
		
		if get_revealed(neighbor):
			continue
		
		results.append(neighbor)
	
	return results


func create_board():
	board.resize(board_rows)
	board_ui.columns = board_cols
	for row in board_rows:
		board[row] = []
		board[row].resize(board_cols)
		
		for col in board_cols:
			var button = Button.new()
			var container = AspectRatioContainer.new()
			container.stretch_mode = AspectRatioContainer.STRETCH_FIT
			container.size_flags_horizontal = Control.SIZE_EXPAND
			container.custom_minimum_size = Vector2(BUTTON_SIZE, BUTTON_SIZE)
			container.custom_maximum_size = Vector2(BUTTON_SIZE, BUTTON_SIZE)
			button.add_theme_color_override("font_disabled_color", Color(1.0, 1.0, 1.0, 1.0))
			button.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT
			button.add_theme_font_size_override("font_size", FONT_SIZE)
			button.add_theme_stylebox_override("normal", CELL_BUTTON)
			button.add_theme_stylebox_override("pressed", CELL_BUTTON)
			button.add_theme_stylebox_override("hover", CELL_BUTTON_HOVER)
			button.add_theme_stylebox_override("disabled", CELL_BUTTON_DISABLED)
			button.text = BLANK
			button.button_down.connect(_button_pressed.bind({"row": row, "col": col}))
			
			container.add_child(button)
			board_ui.add_child(container)
			
			board[row][col] = {
				"adjacency": 0,
				"revealed": false,
				"button": button
			}

	for bomb in board_bombs:
		place_bomb()

	print_board()


func print_board():
	for row in board:
		print(row.map(func (coord): return coord.adjacency))


func place_bomb():
	var placed = false
	while not placed:
		var coords = random_cell_coords()
		print("selected coords ", coords)
		if is_coord_bomb(coords):
			continue
		set_coord(coords, BOMB_SYMBOL)
		increment_adjacent(coords)
		placed = true


func increment_adjacent(coords):
	for delta in ADJACENT_DELTAS:
		var coord = {
			"row": coords.row + delta[0],
			"col": coords.col + delta[1]
		}
		
		if not is_coord_inbounds(coord):
			continue
		if is_coord_bomb(coord):
			continue
		
		set_coord(coord, get_coord(coord) + 1)


func random_cell_coords():
	if board.size() == 0 or board[0].size() == 0:
		printerr("Board must be initialized")
	var row = randi_range(0, board.size() - 1)
	var col = randi_range(0, board[0].size() - 1)
	return {
		"row": row,
		"col": col
	}
	

func get_button(coord):
	return board[coord.row][coord.col].button


func get_revealed(coord):
	return board[coord.row][coord.col].revealed


func set_revealed(coord, is_revealed: bool):
	board[coord.row][coord.col].revealed = is_revealed
	
	if is_revealed:
		revealed += 1
		if revealed == target_reveals:
			win_game.emit()
	
	var button = get_button(coord)
	var cell_value = get_coord(coord)
	
	match cell_value:
		0:
			button.text = ""
		_:
			button.text = str(cell_value)

	button.disabled = true


func get_coord(coord):
	return board[coord.row][coord.col].adjacency


func set_coord(coord, value):
	board[coord.row][coord.col].adjacency = value


func is_coord_bomb(coord):
	match get_coord(coord):
		BOMB_SYMBOL:
			return true
	return false


func is_coord_inbounds(coord):
	if coord.row < 0 or coord.row >= board.size():
		return false
	if coord.col < 0 or coord.col >= board[0].size():
		return false
		
	return true


func _on_new_game_pressed():
	reset()
	create_board()
