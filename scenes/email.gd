extends Control

const PREVIEW = preload("uid://b3vdj7nk56kq")
const DAY_LABEL = preload("uid://csn74aerb25b2")

@onready var avatar = %Avatar
@onready var sender = %Sender
@onready var subject = %Subject
@onready var body = %Body
@onready var email_detailed = %EmailDetailed


var emails: Array = [
	{
		"body": "omg this is so wild the new hire said they'd bring waffles to the whole office that's so kind of them",
		"subject": "BIG NEWS",
		"sender": "IT ANDY",
		"icon": load("res://assets/art/pfps/daisy/daisythehuman (3).svg"),
		"day_sent": 1,
	},
	{
		"body": "I regret to inform you all that I got food poisoning from the waffles yesterday and will not be in the office today. \n\n\n Best,\n Daisy",
		"subject": "Out of Office Notice",
		"sender": "DAISY",
		"day_sent": 2,
	},
	{
		"body": "click this link to send me money! I;ll send you back 10000000X the amount you send me :)",
		"subject": "Monetary Opportunities URGENT",
		"sender": "Prince King",
		"day_sent": 3,
	},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.day_started.connect(load_new_emails)



func load_new_emails(day: int):
	var new_emails = emails.filter(func (email): return email.day_sent == day)
	
	for email in new_emails:
		add_email(email)
	
	if new_emails:
		var instance = DAY_LABEL.instantiate()
		instance.day = day
		add_as_top_email_child(instance)


func add_email(email):
	var instance = PREVIEW.instantiate()
	instance.subject_text = email.subject
	instance.sender_text = email.sender
	if "icon" in email:
		instance.avatar_img = email.icon
	
	instance.pressed.connect(_email_selected.bind(email))
	add_as_top_email_child(instance)

func add_as_top_email_child(child):
	%Emails.add_child(child)
	%Emails.move_child(child, 0)


func _email_selected(email):
	email_detailed.show()
	
	print("selected ", email)
	body.text = email.body
	subject.text = email.subject
	sender.text = email.sender
	if "icon" in email:
		avatar.texture = email.icon
