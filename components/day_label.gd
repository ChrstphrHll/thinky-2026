extends HBoxContainer

var day = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Day.text = "Day " + str(day)
