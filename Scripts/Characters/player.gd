extends CharacterBody2D

@export var BASE_HORIZONTAL_SPEED = 75
@export var BASE_VERTICAL_SPEED = 100
@export var BASE_SLASH_SPEED = 100
@export var BASE_TACKLE_SPEED = 100

@onready var anim_tree = $"Visuals/AnimationTree".get("parameters/playback")
@onready var visuals = $Visuals

@onready var busy = false
@onready var canMove = false
@onready var isDead = false

func _ready():
	var start_HUD = get_node("../Level Start HUD")
	canMove = true
	anim_tree.travel("running")
	velocity.y = -BASE_VERTICAL_SPEED

func _physics_process(delta: float) -> void:
	if canMove:
		_process_horizontal_movement()
	
	move_and_slide()
		
func _process_horizontal_movement() -> void:
	var horizontal_input = Input.get_axis("left","right")
	velocity.x = horizontal_input * BASE_HORIZONTAL_SPEED

func _input(event):
	if event is InputEventMouseButton:
		if anim_tree.get_current_node() == "running":
			
			visuals._create_trailing_effect(5,.05,1)
			anim_tree.travel("sword_swing")
			var mouse_position = get_global_mouse_position()
			var slash_direction = position.direction_to(mouse_position)
			
			velocity += 300 * slash_direction
			rotation = slash_direction.angle() + 90
			
			
			
		
