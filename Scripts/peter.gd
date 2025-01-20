extends CharacterBody2D

@export var baseHorizontalSpeed = 50
@export var baseVerticalSpeed = 100
@export var canMove = false

@onready var animation_tree = $AnimationTree

@onready var slashing = false
@onready var slash_direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	# Begins the 'starting animation'
	animation_tree.set("parameters/playback", "sheathed_run")
	await get_tree().create_timer(2.5).timeout
	canMove = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not slashing:
		if canMove:
			_horizontal_movement()
		_vertical_movement(delta)
	check_slash_hitbox(delta)
	move_and_slide()
	
	
func _input(event):
	if event is InputEventMouseButton:
		if canMove and not slashing:
			slash()

func slash():
	slashing = true
	var mouse_position = get_global_mouse_position()
	slash_direction = (mouse_position - global_position).normalized()
	print("Slash angle: " + str(slash_direction))
	
	animation_tree["parameters/conditions/slashing"] = true
	#rotation = -slash_direction.angle()
	velocity += slash_direction * 200
	await get_tree().create_timer(.4).timeout
	#rotation = 0
	velocity -= slash_direction * 200
	slashing = false
	animation_tree["parameters/conditions/slashing"] = false
	
func check_slash_hitbox(delta):
	var bodies_in_hitbox = $Sword/Hitbox.get_overlapping_bodies()
	for body in bodies_in_hitbox:
		if body.is_in_group("enemy"):
			$"Sword Sound Effects/Hit Sound".play()
			body._death()

func _horizontal_movement():
	var horizontal_input = Input.get_axis("left","right")
	velocity.x = horizontal_input * baseHorizontalSpeed

func _vertical_movement(delta):
	velocity.y = -baseVerticalSpeed * delta * 144
