extends Node2D

@onready var points : int = 0

@onready var time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$PointsLabel.text = "000000"
	

func _change_points(change : int):
	points += change

func _process_points_label():
	var string = str(points).pad_zeros(5)
	$PointsLabel.text = string
	
func _process_time_label():
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	$TimeLabel.text = "%02d:%02d" % [minutes, seconds]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	_process_time_label()
	_process_points_label()

	
