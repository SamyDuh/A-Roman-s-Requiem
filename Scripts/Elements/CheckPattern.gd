extends Sprite2D

# represents order of check pattern (starts at 1)
@export var checkValue : int = 1

@onready var isWaving = false
	
func _ready():
	pass
	
func _start_wave():
	await get_tree().create_timer(checkValue * .1).timeout
	isWaving = true
	_process_wave()

func _process_wave():
	
	
	while isWaving:
		var down_tween = create_tween()
		var up_tween = create_tween()
		var return_tween = create_tween()
		down_tween.tween_property(self,"position:y",-10, .2)
		await down_tween.finished
		up_tween.tween_property(self, "position:y",20, .4)
		await up_tween.finished
		return_tween.tween_property(self,"position:y",-10, .2)
		await return_tween.finished

	

	
	
	
