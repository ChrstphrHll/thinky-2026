extends Control

@onready var animation_player = $Bootup/AnimationPlayer
@onready var bootup = $Bootup
@onready var day_count_label = $Bootup/Day
@onready var point_and_click = $PointAndClick
@onready var admin = %Admin


@onready var time_keeper = %TimeKeeper



# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.day_ended.connect(call_it)
	Signals.day_started.connect(start_day)
	Signals.start_day()
	
	Signals.wallpaper_changed.connect(change_wallpaper)
	Signals.break_taken.connect(take_a_break)
	
	Signals.window_focused.connect(_check_music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$%Time.text = Time.get_time_string_from_system()


func _check_music(window_name: String):
	if window_name == "Cowsweeper":
		play_cowsweeper_music()
	else:
		play_normal_music()


func play_normal_music():
	if $AudioStreamPlayer.playing:
		return
	$CowMusic.play()
	$AudioStreamPlayer.play()


func play_cowsweeper_music():
	if $CowMusic.playing:
		return
	$AudioStreamPlayer.stop()
	$CowMusic.play()


func call_it(day):
	day_count_label.text = "Day " + str(day)
	bootup.show()
	animation_player.play("day_end")
	await animation_player.animation_finished
	Signals.start_day()


func take_a_break():
	fade(func (): point_and_click.show())


func fade(to_run: Callable):
	$Bootup/Day.hide()
	bootup.show()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	to_run.call()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	bootup.hide()
	$Bootup/SplashScreen.color = Color.BLACK
	$Bootup/Day.show()


func start_day(day):
	animation_player.play("day_start")
	await animation_player.animation_finished
	bootup.hide()
	bootup.modulate = Color(1,1,1,1)


func change_wallpaper(texture):
	$Screen.texture = texture


func _on_computer_pressed():
	fade(func (): point_and_click.hide())
