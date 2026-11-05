extends Button


@export var app_name = "Email"
@export var app_icon: CompressedTexture2D = load("res://icon.svg")
@export var connected_window: Control


@onready var texture_rect = $TextureRect
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = app_icon
	label.text = app_name


func _on_pressed():
	connected_window.show()
	connected_window.move_to_front()
