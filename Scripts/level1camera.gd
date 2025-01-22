extends Camera2D

@export var cameraSpeed = 100
@onready var animation_player = $AnimationPlayer

@onready var pause = $pause_menu

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	animation_player.play("godspeedtext")
	get_viewport().focus_entered.connect(_on_window_focus_in)
	get_viewport().focus_exited.connect(_on_window_focus_out)

func _on_window_focus_in():
	pause._tab_in()
	print("Window has gained focus.")

func _on_window_focus_out():
	pause._tab_out()
	pause._pause()

var cameraModifier = 1;

# Called when the node enters the scene tree for the first time.

func _on_timer_timeout():
	cameraModifier+=.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.y -= cameraSpeed * delta * cameraModifier
