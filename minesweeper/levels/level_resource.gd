extends Resource

class_name MinesweeperLevel

@export var board: String


func get_board_info():
	var parsed_board = JSON.parse_string(board)
	var rows = parsed_board.size()
	var cols = parsed_board[0].size()
	var bomb_coords = []
	
	for row in rows:
		for col in cols:
			var value = parsed_board[row][col]
			
			if value:
				bomb_coords.append(
					{
						"row": row,
						"col": col
					})
	
	return {
		"rows": rows,
		"cols": cols,
		"bomb_coords": bomb_coords
	}


func print_data():
	print(board)
