extends Node2D

signal StartGame

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		StartGame.emit()
		queue_free()
