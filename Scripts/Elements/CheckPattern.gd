extends Sprite2D

@export var checkValue: int = 1
@export var distance: float = 10.0

var base_pos: Vector2

func _ready():
	base_pos = position

func start_wave():
	# waits sometime depending on checkValue, helps create delay that causes wave effect
	await get_tree().create_timer(checkValue * .1).timeout

	var wave_tween = create_tween()
	wave_tween.set_loops()
	wave_tween.set_trans(Tween.TRANS_SINE)
	wave_tween.set_ease(Tween.EASE_IN_OUT)

	wave_tween.tween_property(self, "position", base_pos + Vector2(0, -distance), 1)
	wave_tween.tween_property(self, "position", base_pos + Vector2(0,  distance), 2)
	wave_tween.tween_property(self, "position", base_pos, 1)


