extends Node


var day = 1


signal day_started
signal day_ended
signal wallpaper_changed
signal break_taken


func end_day():
	day += 1
	day_ended.emit(day)


func start_day():
	day_started.emit(day)


func new_wallpaper(texture):
	wallpaper_changed.emit(texture)


func take_a_break():
	break_taken.emit()
