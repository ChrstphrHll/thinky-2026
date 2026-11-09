extends Control





func _on_temp_pressed():
	Signals.temp_hired.emit()


func _on_overtime_pressed():
	Signals.overtime_enabled.emit()
