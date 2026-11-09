extends Control



func end_day():
	Signals.end_day()


func _on_break_pressed():
	Signals.take_a_break()
