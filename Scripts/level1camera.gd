extends Camera2D

@export var cameraSpeed = 100
@onready var animation_player = $AnimationPlayer

@onready var circle_transition = $Circle
@onready var circle_shader := circle_transition.material as ShaderMaterial

@onready var sepia_filter = $Sepia 
@onready var sepia_shader := sepia_filter.material as ShaderMaterial

@onready var bolt = $"Revival Bolt"
@onready var flash = $Flash
@onready var flash2 = $"Flash 2"
@onready var player = get_node("../Peter")
@onready var tilemap = get_node("../TileMap")
@onready var velocity_meter = $VelocityMeter

@onready var pause = $pause_menu

# temporary, move to peter function later
@onready var level = get_parent()

@export var revived = false


var moving = false

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

func _on_timer_timeout():
	cameraModifier+=.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if not player.shake_him:
		position.y = player.global_position.y - 100
	
	var bodies_in_hitbox = $"Unload Zone".get_overlapping_bodies()
	for body in bodies_in_hitbox:
		if body.is_in_group("enemy"):
			body.queue_free()
			#body._death()
			#_enemy_hit()
			

func _revive():
	revived = true
	player._update_z_index(10)
	flash.visible = true
	
	bolt.global_position.x = player.global_position.x
	bolt.visible = true
	await get_tree().create_timer(.2).timeout
	level._revival()
	flash.color = Color(0,0,0)
	
	flash2.visible = true
	var flash_tween = create_tween()
	flash2.color.a = 0
	
	flash_tween.tween_property(flash2,"color:a",1, 1.5)
	await flash_tween.finished
	get_tree().reload_current_scene()
	
func _close_in_circle():
	circle_transition.visible = true
	sepia_filter.visible = true
	circle_transition.global_position = player.global_position - Vector2(635,430)
	
	var shader_tween = create_tween()
	var sepia_tween = create_tween()
	sepia_tween.tween_property(sepia_shader, "shader_parameter/intensity",.3,7)
	shader_tween.tween_property(circle_shader, "shader_parameter/circle_size",.1,7)
	if revived: return 0
	await shader_tween.finished
	if revived: return 0
	
	var shader_tween_2 = create_tween()
	var sepia_tween_2 = create_tween()
	sepia_tween_2.tween_property(sepia_shader, "shader_parameter/intensity",.7,5)
	shader_tween_2.tween_property(circle_shader, "shader_parameter/circle_size",.035,5)
	if revived: return 0
	await shader_tween_2.finished
	if revived: return 0
	
	var sepia_tween_3 = create_tween()
	sepia_tween_3.tween_property(sepia_shader, "shader_parameter/intensity",1,3)
	if revived: return 0
	await sepia_tween_3.finished
	if revived: return 0
	
	var shader_tween_3 = create_tween()
	shader_tween_3.tween_property(circle_shader, "shader_parameter/circle_size",0.0,1.5)

