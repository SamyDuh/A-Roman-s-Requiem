extends CharacterBody2D

@export var enemy_indicator = preload("res://Scenes/Menus/enemy_indicator.tscn")
@export var death_sparks = preload("res://Scenes/Menus/death_sparks.tscn")

@onready var animation_player = $AnimationPlayer
@onready var dead = false
@onready var within_distance = false
@onready var distance_to_camera
@onready var camera = get_parent().get_node("Camera")

@onready var indicator_instance = null
@onready var sparks_instance = null
@onready var indicator_freed = false

func _ready():
	pass

func _physics_process(delta):
	#if(indicator_instance != null):
		#print("IM INSTANCING OUT")
		#indicator_instance.position.y -= 1

	distance_to_camera = -((self.global_position) - (camera.get_global_position())).y
	if (distance_to_camera < 500 && !within_distance):
		within_distance = true
		if not dead:
			create_enemy_indicator()
	elif ((distance_to_camera < 90 || distance_to_camera == 0) && !indicator_freed):
		indicator_instance.queue_free()
		indicator_freed = true

func create_enemy_indicator():
	indicator_instance = enemy_indicator.instantiate()
	camera.add_child(indicator_instance)
	indicator_instance.modulate.a = 0
	indicator_instance.position.y -= 155
	indicator_instance.position.x = camera.to_local(position).x - 15
	
	var indicator_player = indicator_instance.get_node("AnimationPlayer")
	indicator_player.play("blink")
	
	for i in 6:
		await get_tree().create_timer(.1).timeout
	

	
func _death():
	if not dead:
		dead = true
		sparks_instance = death_sparks.instantiate()
		self.add_child(sparks_instance)
		sparks_instance.get_node("fire").modulate = Color(1,0,0)
		sparks_instance.get_node("fire").emitting = true
		$CollisionShape2D.disabled = true
		animation_player.play("fall_down")

