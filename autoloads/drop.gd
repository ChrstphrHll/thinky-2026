extends Node

signal drop_zone_changed


func change_drop_zone(zone: Vector2i):
	drop_zone_changed.emit(zone)


func recind_drop_zone():
	drop_zone_changed.emit()
