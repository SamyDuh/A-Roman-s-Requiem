extends Sprite2D

@onready var camera = get_parent().get_node("Camera")

@onready var within_distance = false
@onready var distance_to_camera
@onready var movement_cooldown = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distance_to_camera = -((self.global_position) - (camera.get_global_position())).y
		
	if within_distance and not movement_cooldown:
		position.x += .5
		movement_cooldown = true
		await get_tree().create_timer(.2).timeout
		movement_cooldown = false
	if (distance_to_camera < 500 && !within_distance):
			within_distance = true
