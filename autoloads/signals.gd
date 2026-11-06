extends Node


var day = 0


signal day_started


func start_day():
	day += 1
	day_started.emit(day)
