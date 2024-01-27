extends CharacterBody2D

var praktik

func _physics_process(delta: float) -> void:
	var move := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move * 300
	move_and_slide()
	
	if praktik and Input.is_action_just_pressed("akcja"):
		praktik.practice()
