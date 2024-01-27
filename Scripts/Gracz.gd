extends CharacterBody2D

@onready var how_to_play: Label = $Label
@onready var how_to_devour: Label = $Label2

var jadalne
var praktik

func _physics_process(delta: float) -> void:
	var move := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move * 300
	move_and_slide()
	
	if praktik:
		how_to_play.show()
	else:
		how_to_play.hide()
	
	var is_jadalne: bool = jadalne and jadalne.can_eat()
	if is_jadalne:
		how_to_devour.show()
	else:
		how_to_devour.hide()
	
	if praktik and Input.is_action_just_pressed("akcja"):
		praktik.practice()

	if is_jadalne and Input.is_action_just_pressed("żryj"):
		$Hapsfx.play()
		jadalne.zjedz()
