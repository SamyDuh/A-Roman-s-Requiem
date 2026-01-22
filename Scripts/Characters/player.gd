extends CharacterBody2D

@export var BASE_HORIZONTAL_SPEED = 50
@export var BASE_VERTICAL_SPEED = 50
@export var BASE_SLASH_SPEED = 100
@export var BASE_TACKLE_SPEED = 100

@onready var cape_player = $"Cape Player"
@onready var body_player = $"Body Player"
@onready var arms_player = $"Arms Player"

@onready var canMove = false
@onready var isDead = false

func _ready():
	var start_HUD = get_node("../Level Start HUD")
	if start_HUD: start_HUD.StartGame.connect(_start_player)
	else: print_debug("No Level Start HUD found!")
	body_player.play("Running")
	arms_player.play("Double Arm Swing")
	cape_player.play("Cape Wave")

func _physics_process(delta: float) -> void:
	if canMove:
		_process_horizontal_movement()
	move_and_slide()
		
func _process_horizontal_movement() -> void:
	var horizontal_input = Input.get_axis("left","right")
	velocity.x = horizontal_input * BASE_HORIZONTAL_SPEED

func _start_player(): # called when the StartGame signal is received from the level start HUD
	print("Successful start!")
	arms_player.play("Unsheath")
	canMove = true
	pass
