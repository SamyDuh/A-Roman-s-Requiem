extends CharacterBody2D

@export var enemy_indicator = preload("res://Scenes/Menus/enemy_indicator.tscn")

@onready var animation_player = $AnimationPlayer
@onready var dead = false
@onready var within_distance = false
@onready var distance_to_camera
@onready var camera = get_parent().get_node("Camera")

@onready var indicator_instance = null
@onready var indicator_freed = false

func _ready():
	pass

func _physics_process(delta):
	#if(indicator_instance != null):
		#print("IM INSTANCING OUT")
		#indicator_instance.position.y -= 1

	distance_to_camera = -((self.global_position) - (camera.get_global_position())).y
	print(distance_to_camera)
	if (distance_to_camera < 500 && !within_distance):
		within_distance = true
		create_enemy_indicator()
	elif ((distance_to_camera < 90 || distance_to_camera == 0) && !indicator_freed):
		indicator_instance.queue_free()
		indicator_freed = true

func create_enemy_indicator():
	indicator_instance = enemy_indicator.instantiate()
	camera.add_child(indicator_instance)
	indicator_instance.modulate.a = 0
	indicator_instance.position.y -= 115
	indicator_instance.position.x = camera.to_local(position).x - 15
	
	var indicator_player = indicator_instance.get_node("AnimationPlayer")
	indicator_player.play("blink")
	
	for i in 6:
		await get_tree().create_timer(.1).timeout
		indicator_instance.modulate.a = .2 * i
	

	
func _death():
	if not dead:
		dead = true
		print("The dummy has perished")
		$CollisionShape2D.disabled = true
		animation_player.play("fall_down")
