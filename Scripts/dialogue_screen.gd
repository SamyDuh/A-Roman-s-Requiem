extends Node2D

@onready var textbox = $Box/Text
@onready var text = $Box/Text/Label
@onready var voices = $Voice

# Called when the node enters the scene tree for the first time.
func _ready():
	var blurb = "Hello its me Peter Roman Requeim"
	voices.stream = load("res://Sounds/Character Speech/peter_speech.mp3")
	var length = blurb.length()
	for n in length:
		text.text += blurb[n]
		voices.play()
		await get_tree().create_timer(.04).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
