extends Control

var board: Array[Array] = []

# Game Settings
var board_bombs = 1
var board_bomb_coords = []
var board_rows = 25
var board_cols = 40
var target_reveals = board_rows * board_cols - board_bombs
var revealed = 0
enum game_state { PLAYING, LOST, WON }
var current_game_state = game_state.PLAYING

const BUTTON_SIZE = 26
const FONT_SIZE = 16
const BOMB_SYMBOL = "🐄"
const FLAGGED = "🛸"
const BLANK = "   "
const ADJACENT_DELTAS = [
	[-1, -1], [-1,  0], [-1 ,  1],
	[ 0, -1],           [ 0 ,  1],
	[ 1, -1], [ 1,  0], [ 1 ,  1],
]

const WIN_MESSAGE = "[wave][rainbow]You Win!!!!![/rainbow][/wave]"
const LOSE_MESSAGE = "Ooops. Try Again"

@onready var win_label = $HBoxContainer/CenterContainer/VBoxContainer/Label
@onready var board_ui = $HBoxContainer/CenterContainer/VBoxContainer/Board

const CELL_BUTTON = preload("uid://bcqe48ggyfioa")
const CELL_BUTTON_DISABLED = preload("uid://ds05seb1vtjit")
const CELL_BUTTON_HOVER = preload("uid://b0sex4lta7p8h")
const GRASS_TEXTURES = [
	preload("res://assets/art/cowsweeper_tiles/pasturetile1.svg"),
	preload("res://assets/art/cowsweeper_tiles/pasturetile5.svg"),
	preload("res://assets/art/cowsweeper_tiles/pasturetile2.svg"),
	preload("res://assets/art/cowsweeper_tiles/pasturetile3.svg"),
	preload("res://assets/art/cowsweeper_tiles/pasturetile4.svg"),
	preload("res://assets/art/cowsweeper_tiles/pasturetile6.svg"),
]
const COW_TEXTURE = preload("res://assets/art/cowsweeper_tiles/cowtile.svg")
const ALIEN_TEXTURE = preload("res://assets/art/cowsweeper_tiles/gameovertile.svg")
const HARD = preload("uid://b0yrijjsdky0e")


signal win_game

# Called when the node enters the scene tree for the first time.
func _ready():
	print(HARD.get_board_info())
	create_board()
	win_game.connect(_win_effects)


func _new_game(new_board: int):
	revealed = 0
	current_game_state = game_state.PLAYING
	board = []
	board_ui.modulate = Color(1, 1, 1, 1)
	win_label.hide()
	for node in board_ui.get_children():
		node.queue_free()
	
	create_board(new_board)


func game_over():
	current_game_state = game_state.LOST
	win_label.text = LOSE_MESSAGE
	win_label.show()
	board_ui.modulate = Color(1.0, 0.0, 0.0, 1.0)


func _win_effects():
	current_game_state = game_state.WON
	win_label.text = WIN_MESSAGE
	win_label.show()


func _button_pressed(coords):
	if current_game_state != game_state.PLAYING:
		return
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


func load_level_info(level: MinesweeperLevel):
	var level_info = level.get_board_info()
	board_rows = level_info.rows
	board_cols = level_info.cols
	board_bombs = level_info.bomb_coords.size()
	target_reveals = board_rows * board_cols - board_bombs
	board_bomb_coords = level_info.bomb_coords


func create_board(game_type = 3):
	match game_type:
		0: # Easy
			load_level_info(HARD)
		1: # Medium
			load_level_info(HARD)
		2: # Hard
			load_level_info(HARD)
		3: # random
			board_rows = 20
			board_cols = 30
			board_bombs = 60
			board_bomb_coords = generate_random_bomb_coords(board_bombs)
			target_reveals = board_rows * board_cols - board_bombs

 
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
			button.add_theme_color_override("font_disabled_color", Color.BLACK)
			button.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT
			button.add_theme_font_size_override("font_size", FONT_SIZE)
			button.add_theme_stylebox_override("normal", CELL_BUTTON)
			button.add_theme_stylebox_override("pressed", CELL_BUTTON)
			button.add_theme_stylebox_override("hover", CELL_BUTTON_HOVER)
			var pasture_style = StyleBoxTexture.new()
			if randf() < 0.05:
				pasture_style.texture = COW_TEXTURE
			else:
				pasture_style.texture = GRASS_TEXTURES.pick_random()
			button.add_theme_stylebox_override("disabled", pasture_style)
			
			button.text = BLANK
			button.button_down.connect(_button_pressed.bind({"row": row, "col": col}))
			
			container.add_child(button)
			board_ui.add_child(container)
			
			board[row][col] = {
				"adjacency": 0,
				"revealed": false,
				"button": button
			}

	#for bomb in board_bombs:
		#place_bomb()
	for coord in board_bomb_coords:
		place_bomb(coord)


func print_board():
	for row in board:
		print(row.map(func (coord): return coord.adjacency))


func generate_random_bomb_coords(bombs):
	var coords = []
	while coords.size() < bombs:
		var coord = random_cell_coords(board_rows, board_cols)
		if coord in coords:
			continue
		coords.append(coord)
	
	return coords


func place_bomb(coord):
	set_coord(coord, BOMB_SYMBOL)
	increment_adjacent(coord)


func place_random_bomb():
	var placed = false
	while not placed:
		var coords = random_cell_coords(board_rows, board_cols)
		if is_coord_bomb(coords):
			continue
		place_bomb(coords)
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


func random_cell_coords(rows, cols):
	var row = randi_range(0, rows - 1)
	var col = randi_range(0, cols - 1)
	return {
		"row": row,
		"col": col
	}
	

func get_button(coord):
	return board[coord.row][coord.col].button


func get_revealed(coord):
	return board[coord.row][coord.col].revealed


func set_revealed(coord, is_revealed: bool):
	if not is_revealed or get_revealed(coord):
		return

	board[coord.row][coord.col].revealed = true

	var button = get_button(coord)
	var cell_value = get_coord(coord)

	if is_coord_bomb(coord):
		var alien_style = StyleBoxTexture.new()
		alien_style.texture = ALIEN_TEXTURE
		button.add_theme_stylebox_override("disabled", alien_style)
		button.text = ""
	else:
		if cell_value == 0:
			button.text = ""
		else:
			button.text = str(cell_value)

	button.disabled = true

	if not is_coord_bomb(coord):
		revealed += 1
		if revealed == target_reveals:
			win_game.emit()




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
