extends Node2D

@onready var bgm: AudioStreamPlayer = $BackgroundMusic

func _ready():
	bgm.play(120.0)
	bgm.stream.loop = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
