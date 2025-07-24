extends Node2D

@onready var BGM = $Camera/BGM

var OverworldBGM: AudioStream = load("res://Music/level_1_theme.mp3")
var DeathBGM: AudioStream = load("res://Music/game_over_theme.mp3")
var RevivalSFX: AudioStream = load("res://Sounds/thunder_strike.mp3")

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_bgm():
	BGM.set_stream(OverworldBGM)
	OverworldBGM.loop = true
	BGM.play()

func _death():
	BGM.stop()
	DeathBGM.loop = false
	BGM.set_stream(DeathBGM)
	BGM.play()
	
func _revival():
	BGM.stop()
	RevivalSFX.loop = false
	BGM.set_stream(RevivalSFX)
	BGM.play()
