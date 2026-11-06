extends Control

@onready var animation_player = $Bootup/AnimationPlayer
@onready var bootup = $Bootup
@onready var day_count_label = $Bootup/Day


@onready var time_keeper = %TimeKeeper



# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.day_started.connect(call_it)
	Signals.start_day()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$%Time.text = Time.get_time_string_from_system()


func call_it(day):
	day_count_label.text = "Day " + str(day)
	bootup.show()
	animation_player.play("next_day")
	await animation_player.animation_finished
	bootup.hide()
