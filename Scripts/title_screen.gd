extends Control

@onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("flame_lighting_flicker")
	$OptionsBox/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_exit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")



func _on_dialogue_scene_pressed():
	get_tree().change_scene_to_file("res://Scenes/dialogue_screen.tscn")
