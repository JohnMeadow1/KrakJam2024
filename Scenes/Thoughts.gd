extends Node2D
@onready var label = $Dymki/Label
@onready var animation_player = $AnimationPlayer

func think(text:String):
	if animation_player.is_playing():
		animation_player.stop()
	
	animation_player.play("think")
	label.text = text
