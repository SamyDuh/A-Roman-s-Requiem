extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_children():
		if child.is_in_group("check_pattern"):
			child.start_wave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
