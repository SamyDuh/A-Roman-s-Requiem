extends CharacterBody2D

@export var ARM_LENGTH: int
@export var RUN_SPEED: int
@export var WEAPON: String

@onready var right_arm = $"Right Arm"
@onready var left_arm = $"Left Arm"
@onready var weapon_node
@onready var is_alive = true

func _ready() -> void:
	var weapon_prefab = WeaponDictionary.WEAPON_PREFABS.get(WEAPON)
	weapon_node = weapon_prefab.instantiate()
	left_arm.add_child(weapon_node)
	weapon_node.position.y += ARM_LENGTH
	$"Animation Player".play("run")
	pass
