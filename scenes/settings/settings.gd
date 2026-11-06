extends Control


@onready var background_panel = $MarginContainer/HBoxContainer/VBoxContainer2/BackgroundPanel
@onready var audio_panel = $MarginContainer/HBoxContainer/VBoxContainer2/AudioPanel
@onready var advanced_settings_panel = $MarginContainer/HBoxContainer/VBoxContainer2/AdvancedSettingsPanel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func toggle_node_visibility(node, toggle):
	if toggle:
		node.show()
	else:
		node.hide()


func _on_background_toggled(toggled_on):
	toggle_node_visibility(background_panel, toggled_on)


func _on_audio_toggled(toggled_on):
	toggle_node_visibility(audio_panel, toggled_on)


func _on_admin_access_toggled(toggled_on):
	toggle_node_visibility(advanced_settings_panel, toggled_on)
