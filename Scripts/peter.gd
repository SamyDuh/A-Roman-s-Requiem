extends CharacterBody2D

@export var baseHorizontalSpeed = 50
@export var baseVerticalSpeed = 40
@export var canMove = false

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var velocity_meter = get_parent().get_node("Camera/VelocityMeter")

@onready var slashing = false
@onready var holding = false
@onready var enemy_hit = false
@onready var invalid_slash = false
@onready var velocity_modifier = 1
@onready var slash_direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	# Begins the 'starting animation'
	animation_tree.set("parameters/playback", "sheathed_run")
	await get_tree().create_timer(2.9).timeout
	canMove = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("hold") and canMove and not slashing:
		print("Im holding out man")
		velocity.y = 0
		velocity.x = 0
		if state_machine.get_current_node() != "hold":
			holding = true
			state_machine.travel("hold")
		return
	else:
		holding = false
		if state_machine.get_current_node() == "hold":
			state_machine.travel("unsheated_run")
	if not slashing and not holding:
		if canMove:
			_horizontal_movement()
		_vertical_movement(delta)
	if slashing:
		check_slash_hitbox(delta)
	move_and_slide()
	velocity_meter._update_bar(velocity_modifier)
	
	
func _input(event):
	if event is InputEventMouseButton:
		if canMove and not slashing:
			slash()

func slash():
	
	var mouse_position = get_global_mouse_position()
	slash_direction = (mouse_position - global_position).normalized()
	var rotation_angle = figure_slash_angle(slash_direction.angle())
	if invalid_slash or holding:
		invalid_slash = false
		return 0
	slashing = true
	animation_tree["parameters/conditions/slashing"] = true
	rotation = rotation_angle
	var saved_modifier = velocity_modifier
	velocity += slash_direction * 200 * saved_modifier
	await get_tree().create_timer(.4).timeout
	rotation = 0
	velocity -= slash_direction * 200 * saved_modifier
	if not enemy_hit:
		velocity_modifier -= .2
	else:
		enemy_hit = false
	slashing = false
	animation_tree["parameters/conditions/slashing"] = false
	
func figure_slash_angle(angle):
	match true:
		_ when angle > -.5 && angle <= 0:
			print("returning -30")
			return -30
		_ when angle > -1 && angle <= -.5:
			print("returning -50")
			return -50
		_ when angle >= -2 && angle <= -1:
			print("returning 0")
			return 0
		_ when angle >= -2.5 && angle < -2:
			print("returning 50")
			return 50
		_ when angle >= -3 && angle < -2.5:
			print("returning 30")
			return 30
		_:
			print("returning invalid angle")
			invalid_slash = true
			return 0
	
	
func check_slash_hitbox(delta):
	var bodies_in_hitbox = $Sword/Hitbox.get_overlapping_bodies()
	for body in bodies_in_hitbox:
		if body.is_in_group("enemy"):
			$"Sword Sound Effects/Hit Sound".play()
			body._death()
			_enemy_hit()
			

func _enemy_hit():
	velocity_modifier += .1
	enemy_hit = true
	$V_DeprecationTimer.start()

func _horizontal_movement():
	var horizontal_input = Input.get_axis("left","right")
	velocity.x = horizontal_input * baseHorizontalSpeed

func _vertical_movement(delta):
	velocity.y = -baseVerticalSpeed * delta * 150 * velocity_modifier


func _on_v_deprecation_timer_timeout():
	velocity_modifier -= .01
	print(velocity_modifier)
