extends CharacterBody2D

@onready var how_to_play: Label = $Label

var praktik

func _physics_process(delta: float) -> void:
	var move := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move * 300
	move_and_slide()
	
	if praktik:
		how_to_play.show()
	else:
		how_to_play.hide()
	
	if praktik and Input.is_action_just_pressed("akcja"):
		praktik.practice()
