extends TextureButton


var hovered = false


# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(func (): hovered = true)
	mouse_exited.connect(func (): hovered = false)
	
	pressed.connect(select_wallpaper)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered or button_pressed:
		modulate.a = 1
	else: 
		modulate.a = 0.7


func select_wallpaper():
	Signals.new_wallpaper(texture_normal)
