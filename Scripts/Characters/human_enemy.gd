extends CharacterBody2D

@export var ARM_LENGTH: int
@export var RUN_SPEED: int
@export var WEAPON: String

# Sprites
@onready var Head: Sprite2D = $SubViewport/Head
@onready var Body: Sprite2D = $SubViewport/Body
@onready var RightArm: Sprite2D = $"SubViewport/Right Arm"
@onready var RightShoulder: Sprite2D = $"SubViewport/Right Shoulder"
@onready var LeftArm: Sprite2D = $"SubViewport/Left Arm"
@onready var LeftShoulder: Sprite2D = $"SubViewport/Left Shoulder"

# Animation players
@onready var HeadPlayer: AnimationPlayer = $"Animation Players/Head Player"
@onready var BodyPlayer: AnimationPlayer = $"Animation Players/Body Player"
@onready var RArmPlayer: AnimationPlayer = $"Animation Players/RArm Player"
@onready var LArmPlayer: AnimationPlayer = $"Animation Players/LArm Player"

@onready var WeaponNode
@onready var is_alive = true

func _ready() -> void:
	var weapon_prefab = WeaponDictionary.WEAPON_PREFABS.get(WEAPON)
	WeaponNode = weapon_prefab.instantiate()
	LeftArm.add_child(WeaponNode)
	WeaponNode.position.y += ARM_LENGTH

	HeadPlayer.play("animate")
	BodyPlayer.play("run")
	LArmPlayer.play("swing")
	RArmPlayer.play("swing")
	pass
