extends CharacterBody2D

@export var BASE_HORIZONTAL_SPEED = 75
@export var BASE_VERTICAL_SPEED = 100
@export var BASE_SLASH_SPEED = 100
@export var BASE_TACKLE_SPEED = 100

@onready var anim_tree = $"SubViewport/Visuals/AnimationTree".get("parameters/playback")
@onready var visuals = $"SubViewport/Visuals"

@onready var canMove = false
@onready var isDead = false

@onready var busy = false
@onready var facing_left = true


@onready var isDashing = false


func _ready():
	#var start_HUD = get_node("../Level Start HUD")
	canMove = true
	anim_tree.travel("running")
	velocity.y = -BASE_VERTICAL_SPEED

func _physics_process(delta: float) -> void:
	_consolidate_status()
	if !busy:
		_process_horizontal_movement()
	
	move_and_slide()
	
func _consolidate_status():
	if isDashing || !canMove :
		busy = true
	else:
		busy = false
		
func _process_horizontal_movement() -> void:
	var horizontal_input = Input.get_axis("left","right")
	velocity.x = horizontal_input * BASE_HORIZONTAL_SPEED

func _input(event):
	if event is InputEventMouseButton:
		dash()
			
		
		
func dash():
	if anim_tree.get_current_node() == "running_left" || anim_tree.get_current_node() == "running_right":
		
		var mouse_position = get_global_mouse_position()
		var slash_direction = position.direction_to(mouse_position)
		
		# checks and applies the dash's angle
		var degrees_angle = rad_to_deg(slash_direction.angle()) + 90
		print(degrees_angle)
		if abs(degrees_angle) > 80:
			print("Invalid slash angle!")
			return
		elif abs(degrees_angle) > 25:
			rotation_degrees = 25 * sign(degrees_angle)
			
		
		isDashing = true
		velocity += 400 * slash_direction
		visuals.createTrailingEffect(10,.05,.25)
		
		if facing_left:
			anim_tree.travel("sword_swing_LR")
			facing_left = false
		else:
			anim_tree.travel("sword_swing_RL")
			facing_left = true
		
		
		await get_tree().create_timer(.5).timeout
		
		isDashing = false
		rotation = 0
		velocity -= 400 * slash_direction
