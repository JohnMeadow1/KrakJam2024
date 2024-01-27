extends CharacterBody2D

@onready var how_to_play: Label = $Label
@onready var how_to_devour: Label = $Label2
@onready var nanimator: AnimationPlayer = $AnimationPlayer
@onready var pragnienieniemaszansz_2d: Sprite2D = $Sprite2D

var jadalne
var praktik

var chapczy: bool

func _physics_process(delta: float) -> void:
	var move := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move * 300
	move_and_slide()
	
	if not chapczy:
		if velocity.is_zero_approx():
			nanimator.play(&"Stanie")
		else:
			nanimator.play(&"Chodzenie")
	
	if velocity.x > 0:
		pragnienieniemaszansz_2d.scale = Vector2(1, 1)
	else:
		pragnienieniemaszansz_2d.scale = Vector2(-1, 1)
	
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
		jadalne.zjedz()
		
		if not chapczy:
			chapczy = true
			nanimator.play(&"Chaparka")
			await nanimator.animation_finished
			chapczy = false
