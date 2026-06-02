extends Node2D

# fetches the Sprite2D from our sub viewport
@onready var Player = get_parent().get_parent()
@onready var PlayerCopy = get_parent().get_parent().get_node("SubOutput")
@onready var FadeScript = load("res://Scripts/Effects/fade_away.gd")

@onready var cloneMaterial = load("res://Assets/Shaders/phantom_material.tres")

@onready var cape
@onready var head
@onready var body
@onready var larm
@onready var sword
@onready var land
@onready var rarm
@onready var legs

@onready var outline_tween: Tween

func _ready() -> void:
	
	cape = get_node("Cape")
	head = get_node("Head")
	body = get_node("Body")
	larm = get_node("LArm")
	sword = larm.get_node("Sword")
	land = larm.get_node("LHand")
	rarm = get_node("RArm")
	legs = get_node("Legs")
	
	outline_tween = get_tree().create_tween()
	outline_tween.set_loops()
	outline_tween.tween_property(PlayerCopy.material,"shader_parameter/color",Color.TRANSPARENT,1)
	outline_tween.tween_property(PlayerCopy.material,"shader_parameter/color",Color.WHITE,1)
	
	

func createTrailingEffect(amount: int, frequency_sec: float,
 longevity_sec: float, color: Color = 1) -> void:

	for i in range(amount):
		
		await RenderingServer.frame_post_draw
		
		
		var copy = Sprite2D.new()
		
		var img = PlayerCopy.get_texture().get_image()
		copy.texture = ImageTexture.create_from_image(img)
		copy.material = cloneMaterial
		copy.z_index = 17
		
		copy.set_script(FadeScript)
		
		Player.get_parent().add_child(copy) # adds to main level scene
		copy.global_transform = Player.global_transform
		copy._fade_out(longevity_sec)
		
		copy.modulate = Color.BLUE
		
		await get_tree().create_timer(frequency_sec).timeout

	
	
	
