extends Control

@export var BACKGROUND_BLUR = false

@export var SETTINGS_PATH: PackedScene
@export var MAIN_MENU_PATH: PackedScene


func _ready() -> void:

	if SETTINGS_PATH == null: $ButtonContainer/SettingsButton.visible = false
	if MAIN_MENU_PATH == null: $ButtonContainer/MainMenuButton.visible = false
	if BACKGROUND_BLUR: $Blur.visible = true


func _process(delta) -> void:
	if Input.is_action_just_pressed("Pause"):
		_toggle_pause()

func _toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	visible = !visible




func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_resume_button_button_up() -> void:
	_toggle_pause()
