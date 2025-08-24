extends VBoxContainer

var preloading : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.musicOn:
		$"Music Icon/Music Checkbox".button_pressed = true
	if Global.fullscreenOn:
		$"Fullscreen Icon/Fullscreen Checkbox".button_pressed = true
	preloading = false 


# Called every frame. 'delta' is the elapsed time since the previous frame.





func _on_music_checkbox_toggled(toggled_on):
	if not preloading:
		Global.musicOn = !Global.musicOn


func _on_fullscreen_checkbox_toggled(toggled_on):
	if not preloading:
		Global.fullscreenOn = !Global.fullscreenOn
		Global._toggle_fullscreen()
