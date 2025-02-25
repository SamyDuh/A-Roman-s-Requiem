extends Node2D

@onready var velocity_meter = $VelocityProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity_meter.value = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update_bar(velocity):
	velocity_meter.value = velocity
