extends Node2D
@onready var label = $Dymki/Label
@onready var animation_player = $AnimationPlayer

func think(text:String):
	if not animation_player.is_playing():
		animation_player.play("think")
	else:
		animation_player.seek(0.0)
	label.text = text
