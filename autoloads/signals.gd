extends Node


var day = 1


signal day_started
signal day_ended


func end_day():
	day += 1
	day_ended.emit(day)


func start_day():
	day_started.emit(day)
