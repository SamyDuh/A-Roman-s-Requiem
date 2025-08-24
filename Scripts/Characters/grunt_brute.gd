extends CharacterBody2D

@export var enemy_indicator = preload("res://Scenes/Menus/enemy_indicator.tscn")
@export var death_sparks = preload("res://Scenes/Menus/death_sparks.tscn")



@onready var dead = false
@onready var within_distance = false
@onready var distance_to_camera
@onready var camera = get_parent().get_node("Camera")
@onready var player = get_parent().get_node("Peter")

@onready var indicator_instance = null
@onready var sparks_instance = null
@onready var indicator_freed = false

@onready var shield_protection = false

func _ready():
	$BodyPlayer.play("Walk",-1,.85)
	$TasselPlayer.play("tassel",-1,.85)
	pass

func _physics_process(delta):
	#if(indicator_instance != null):
		#print("IM INSTANCING OUT")
		#indicator_instance.position.y -= 1
	if not dead:
		var bodies_in_hitbox = $Hitbox.get_overlapping_bodies()
		for body in bodies_in_hitbox:
			if body.is_in_group("player"):
				body._take_damage()
		

		distance_to_camera = -((self.global_position) - (camera.get_global_position())).y
		
		if within_distance && (distance_to_camera < 200):
			velocity.y = 60
			move_and_slide()
		if (distance_to_camera < 500 && !within_distance):
			within_distance = true
			create_enemy_indicator()
		elif ((distance_to_camera < 90 || distance_to_camera == 0) && !indicator_freed):
			indicator_instance.queue_free()
			indicator_freed = true

func create_enemy_indicator():
	if dead:
		return 0
	indicator_instance = enemy_indicator.instantiate()
	camera.add_child(indicator_instance)
	indicator_instance.modulate.a = 0
	indicator_instance.position.y -= 155
	indicator_instance.position.x = camera.to_local(position).x - 15
	
	var indicator_player = indicator_instance.get_node("AnimationPlayer")
	indicator_player.play("blink")
	
	for i in 6:
		if not dead:
			await get_tree().create_timer(.1).timeout
			indicator_instance.modulate.a = .2 * i
	

	
func _death():
	if shield_protection:
		return 0
	var player_attack = (player.position - global_position).normalized()
	if abs(Vector2.DOWN.angle_to(player_attack)) <= deg_to_rad(70.0):
		print("Get blocked loser")
		$CollisionShape2D.disabled = true
		shield_protection = true
		await get_tree().create_timer(2)
		shield_protection = false
		$CollisionShape2D.disabled = false
		
		return 0
	if not dead:
		dead = true
		sparks_instance = death_sparks.instantiate()
		self.add_child(sparks_instance)
		sparks_instance.get_node("fire").emitting = true
		$CollisionShape2D.disabled = true
		$Body.visible = false
		#animation_player.play("death")
