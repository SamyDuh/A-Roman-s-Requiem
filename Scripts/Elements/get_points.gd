extends Node2D

@onready var label = $Label



# Called when the node enters the scene tree for the first time.
func _ready():
	label.modulate.a = 0
	#_fade_in()

func _set_points(number: int, pos : Vector2):
	position = pos
	$Label.text = str(number)
	_fade_in()

func _fade_in():
	print("Am i even real brah")
	var fade_in_tween = create_tween()
	var move_in_tween = create_tween()
	
	move_in_tween.tween_property(self, "position", position + Vector2(0,-30),.3)
	fade_in_tween.tween_property($Label,"modulate:a",1,.3)
	await fade_in_tween.finished
	print("Im fading in brah")
	
	var middle_tween = create_tween()
	middle_tween.tween_property(self, "position", position + Vector2(0,-20),1)
	await middle_tween.finished
	print("Im middling brah")
	
	var fade_out_tween = create_tween()
	var move_out_tween = create_tween()
	
	move_out_tween.tween_property(self, "position", position + Vector2(0,-10),.6)
	fade_out_tween.tween_property($Label,"modulate:a",0,.6)
	print("Im fading out brah")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
