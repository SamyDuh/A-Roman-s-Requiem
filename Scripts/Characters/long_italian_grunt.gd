extends CharacterBody2D

@export var enemy_indicator = preload("res://Scenes/Menus/enemy_indicator.tscn")
@export var death_sparks = preload("res://Scenes/Menus/death_sparks.tscn")

@export var pushModifier = 150

@export var points_worth = 150

@onready var animation_player = $AnimationPlayer
@onready var dead = false
@onready var within_distance = false
@onready var distance_to_camera
@onready var camera = get_parent().get_node("Camera")
@onready var player = get_parent().get_node("Peter")

@onready var indicator_instance = null
@onready var sparks_instance = null
@onready var indicator_freed = false


#spear exclusive variables
@onready var using_spear = false



@onready var lock_spear = false

func _ready():
	animation_player.play("running",-1,.85)
	pass

func _physics_process(delta):
	#if(indicator_instance != null):
		#print("IM INSTANCING OUT")
		#indicator_instance.position.y -= 1
	if not dead:
		var bodies_in_hitbox = $"Spear Pivot/Spear/Spear Hurtbox".get_overlapping_bodies()
		for body in bodies_in_hitbox:
			if body.is_in_group("player"):
				body._take_damage()
		
		
		if within_distance and (not lock_spear or using_spear):
			var to_player = player.global_position - global_position
			var spear_angle = clamp(to_player.angle() - 1,-.85,2)
			
			if spear_angle == -.85 or spear_angle == 2:
				_lock_spear()
			$"Spear Pivot".global_rotation = spear_angle
			
			if not using_spear:
				_hold_back_spear()
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
			
	if dead:
		move_and_slide()

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
			
			indicator_instance.modulate.a = .2 * i
	
func _lock_spear() -> void:
	lock_spear = true
	var rotation_tween = create_tween()
	rotation_tween.tween_property($"Spear Pivot","global_rotation",0,1)
	
func _hold_back_spear() -> void:
	using_spear = true
	var back_tween = create_tween()
	print("Im holding out bro")
	back_tween.tween_property($"Spear Pivot","position.y",3,1)
	await back_tween.finished
	
	_thrust_spear()
	
func _thrust_spear() -> void:
	var thrust_tween = create_tween()
	
	thrust_tween.tween_property($"Spear Pivot","position.y",-6,.2)
	print("Im thrusting bro")
	await thrust_tween.finished
	await get_tree().create_timer(.5).timeout
	using_spear = false
	
	
	
func _death():
	if not dead:
		dead = true
		
		var points_popup_scene = preload("res://Scripts/Elements/points.tscn")
		var points_popup = points_popup_scene.instantiate()
		get_tree().current_scene.add_child(points_popup)
		points_popup._set_points(points_worth,Vector2(position.x + 40, position.y))
		get_parent().get_node("Camera/points_counter")._change_points(points_worth)
		
		sparks_instance = death_sparks.instantiate()
		self.add_child(sparks_instance)
		sparks_instance.get_node("fire").emitting = true
		$CollisionShape2D.disabled = true
		animation_player.play("death")
		
		var direction_from_player = self.position - player.position
	
		velocity = direction_from_player.normalized() * pushModifier
		self.rotation = direction_from_player.angle() + 90
		await get_tree().create_timer(.2).timeout
		velocity = Vector2(0,0)
