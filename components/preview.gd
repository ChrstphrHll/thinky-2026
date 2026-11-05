extends Button


var subject_text: String
var sender_text: String
var avatar_img: CompressedTexture2D


@onready var sender = $MarginContainer/HBoxContainer/VBoxContainer/Sender
@onready var subject = $MarginContainer/HBoxContainer/VBoxContainer/Subject
@onready var avatar = $MarginContainer/HBoxContainer/Avatar


# Called when the node enters the scene tree for the first time.
func _ready():
	if sender_text:
		sender.text = sender_text
	
	if subject_text:
		subject.text = subject_text
	
	if avatar_img:
		avatar.texture = avatar_img
