extends Camera2D

@export var VERTICAL_OFFSET = -130


@onready var player = get_parent().get_node("NewPeter")

func _process(delta: float) -> void:
	position.y = player.position.y + VERTICAL_OFFSET
