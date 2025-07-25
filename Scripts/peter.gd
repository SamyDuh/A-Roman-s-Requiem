extends CharacterBody2D

@export var baseHorizontalSpeed = 50
@export var baseVerticalSpeed = 40
@export var canMove = false

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var cam = get_node("../Camera")
@onready var velocity_meter = get_parent().get_node("Camera/VelocityMeter")
@onready var tilemap = get_node("../TileMap")
@onready var level = get_parent()

@onready var inv_frames = false
@onready var slashing = false
@onready var holding = false
@onready var dead = false
@onready var really_dead = false
@onready var enemy_hit = false
@onready var invalid_slash = false
@onready var shake_him = false
@onready var velocity_modifier = 1
@onready var tile_modifier = 1
@onready var slash_direction = Vector2.ZERO

@onready var death_pos = position
@onready var shaking = true

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	# Begins the 'starting animation'
	animation_tree.set("parameters/playback", "sheathed_run")
	await get_tree().create_timer(2.9).timeout
	canMove = true
	level._start_bgm()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Prevents velocity from being negative
	if velocity_modifier < 0 and not dead:
		velocity_modifier = 0
		_death()
		
	if dead and not really_dead:
		if Input.is_action_pressed("revive"):
			cam._revive()
	if shake_him:
		if shaking:
			var shake_offset = Vector2(randf_range(-.5,.5), randf_range(-.5,.5))
			position = death_pos + shake_offset
			await get_tree().create_timer(1).timeout
			shaking = false
		else:
			await get_tree().create_timer(1.5).timeout
			shaking = true
			
	
	if not dead:
		if tile_modifier < 1:
			velocity_meter.light_shake = true
		else:
			velocity_meter.light_shake = false
			
			
		var cell : Vector2i = tilemap.local_to_map(global_position)
		var data: TileData = tilemap.get_cell_tile_data(1,cell)
		
		if data:
			tile_modifier = data.get_custom_data("movement_change")
		else:
			tile_modifier = 1
				
		if Input.is_action_pressed("hold") and canMove and not slashing or dead and holding:
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
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				slash()
			elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				dash()

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
	
# i gotta fix the angle values, they work but they use really awkward radian numbers instead of the simplest ones
func figure_slash_angle(angle):
	match true:
		_ when angle > -.5 && angle <= 0:
			print("returning 70")
			return 70
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
			print("returning -70")
			return -70
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
			
			
func dash():
	if holding:
		return 0
	slashing = true
	if velocity.x > 0:
		animation_tree["parameters/conditions/dashing_right"] = true
		velocity.x += 300
		await get_tree().create_timer(.35).timeout
		velocity.x -= 300
		animation_tree["parameters/conditions/dashing_right"] = false
		
	else:
		animation_tree["parameters/conditions/dashing_left"] = true
		velocity.x -= 250
		await get_tree().create_timer(.35).timeout
		velocity.x += 250
		animation_tree["parameters/conditions/dashing_left"] = false
		
		if not enemy_hit:
			velocity_modifier -= .05
		else:
			enemy_hit = false
	
	slashing = false

func _enemy_hit():
	velocity_modifier += .1
	enemy_hit = true
	$V_DeprecationTimer.start()

func _horizontal_movement():
	var horizontal_input = Input.get_axis("left","right")
	velocity.x = horizontal_input * baseHorizontalSpeed

func _vertical_movement(delta):
	velocity.y = -baseVerticalSpeed * delta * 150 * velocity_modifier * tile_modifier
	
func _take_damage():
	if not inv_frames:
		inv_frames = true
		_invincibility_window()
		$"Take Damage".play()
		velocity_modifier -= .2
		
func _invincibility_window():
	_modulate_peter(1,0,0,.9)
	velocity_meter.heavy_shake = true
	await get_tree().create_timer(1).timeout
	velocity_meter.heavy_shake = false
	_modulate_peter(1,1,1,1)
	inv_frames = false
	

func _modulate_peter(a, b, c, d):
	$Body.self_modulate = Color(a,b,c,d)
	$Head.self_modulate = Color(a,b,c,d)
	$Cape.self_modulate = Color(a,b,c,d)
	$Sword.self_modulate = Color(a,b,c,d)
	$"Left Arm".self_modulate = Color(a,b,c,d)
	$"Left Arm/Left Hand".self_modulate = Color(a,b,c,d)
	$"Right Arm".self_modulate = Color(a,b,c,d)
	$Aura.self_modulate = Color(a,b,c,d)
	$HAura.self_modulate = Color(a,b,c,d)
	$Sword/Slash.self_modulate = Color(a,b,c,d)

func _on_v_deprecation_timer_timeout():
	velocity_modifier -= .01
	
func _death():
	dead = true
	death_pos = position
	shake_him = true
	
	level._death()
	cam._close_in_circle()
	
	animation_tree["parameters/conditions/holding"] = true
	await get_tree().create_timer(14).timeout
	if cam.revived: return 0
	position = death_pos
	shake_him = false
	animation_tree["parameters/conditions/dead"] = true
	$"Take Damage".play()
	
func _update_z_index(a):
	$Body.z_index += a
	$Head.z_index += a
	$Cape.z_index += a
	$Sword.z_index += a
	$"Left Arm".z_index += a
	$"Left Arm/Left Hand".z_index += a
	$"Right Arm".z_index += a
	$Aura.z_index += a
	$HAura.z_index += a
	$Sword/Slash.z_index += a
	


