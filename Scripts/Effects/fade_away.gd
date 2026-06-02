extends Sprite2D

func _fade_out(fade_seconds: float):

	visible = true
	var fade_tween = create_tween() 
	fade_tween.tween_property(self, "modulate:a",0, fade_seconds)
	await fade_tween.finished
	free()
