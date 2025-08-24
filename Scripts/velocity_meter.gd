extends Node2D

@onready var velocity_meter = $VelocityProgress
@onready var light_shake = false
@onready var heavy_shake = false

var original_pos: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	original_pos = position
	velocity_meter.value = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if heavy_shake: 
		var shake_offset = Vector2(randf_range(-10,10), randf_range(-10,10))
		$Meter.self_modulate = Color(.7,0,0)
		$VelocityProgress.self_modulate = Color(.7,0,0)
		position = original_pos + shake_offset
	elif light_shake:
		var shake_offset = Vector2(randf_range(-3,3), randf_range(-3,3))
		position = original_pos + shake_offset
	else:
		$Meter.self_modulate = Color(1,1,1)
		$VelocityProgress.self_modulate = Color(1,1,1)
		position = original_pos
	

func _death_bar():
	$Meter/Crack.visible = true
	heavy_shake = true
	_update_bar(0)
	await get_tree().create_timer(1).timeout
	heavy_shake = false

func _update_bar(velocity):
	var bar_tween = create_tween()
	bar_tween.tween_property(velocity_meter,"value",velocity,.5)
	#velocity_meter.value = velocity
