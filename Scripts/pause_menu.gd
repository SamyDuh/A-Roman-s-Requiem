extends Control

@onready var tabbedIn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().paused:
			_pause()
		else:
			get_tree().paused = false
			visible = false


func _pause():
	if is_inside_tree():
		get_tree().paused = true
		visible = true
		
func _tab_out():
	tabbedIn = false
	
func _tab_in():
	await get_tree().create_timer(.3).timeout
	tabbedIn = true


func _on_exit_button_pressed():
	if tabbedIn:
		get_tree().quit()


func _on_resume_button_pressed():
	if tabbedIn:
		get_tree().paused = false
		visible = false


func _on_return_button_pressed():
	if tabbedIn:
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
		
