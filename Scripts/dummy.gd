extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var dead = false

func _ready():
	pass

	
func _death():
	if not dead:
		dead = true
		print("The dummy has perished")
		$CollisionShape2D.disabled = true
		animation_player.play("fall_down")
