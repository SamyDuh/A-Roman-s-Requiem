extends Node2D

# determines where on the sprite (-y axis) the handle is aka where the enemy will grab it from
@export var HANDLE_POSITION_MAIN: int

# determines a secondary handle position if the weapon is two-handed (0 by default)
@export var HANDLE_POSITION_SIDE: int = 0

# Weapon -> Arm Sprite -> SubViewport -> Holder
@onready var WeaponHolder = get_parent().get_parent().get_parent()

func _ready() -> void:
	position.y += HANDLE_POSITION_MAIN
	_weapon_start()
	
	if HANDLE_POSITION_SIDE == 0:
		_right_arm_loop()
	
func _weapon_start():
	pass

func _right_arm_loop():
	var arm_tween = create_tween()
	var RightArm = WeaponHolder.RightArm
	
	arm_tween.set_loops()
	
	arm_tween.tween_property(RightArm,"skew",deg_to_rad(5),.5)
	arm_tween.tween_property(RightArm,"skew",deg_to_rad(-5),.5)
	
