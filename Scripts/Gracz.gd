extends CharacterBody2D

@onready var how_to_play: Label = $Label
@onready var how_to_devour: Label = $Label2
@onready var nanimator: AnimationPlayer = $AnimationPlayer
@onready var pragnienieniemaszansz_2d: Sprite2D = $Sprite2D

var jadalne: Array
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
	elif velocity.x < 0:
		pragnienieniemaszansz_2d.scale = Vector2(-1, 1)
	
	if praktik:
		how_to_play.show()
	else:
		how_to_play.hide()
	
	var yadalne
	for yada in jadalne:
		if yada.can_eat() and (not yadalne or yada.global_position.distance_squared_to(global_position) < yadalne.global_position.distance_squared_to(global_position)):
			yadalne = yada
	
	if yadalne:
		how_to_devour.show()
	else:
		how_to_devour.hide()
	
	if praktik and Input.is_action_just_pressed("akcja"):
		praktik.practice()

	if yadalne and Input.is_action_just_pressed("żryj"):
		yadalne.zjedz()
		
		if not chapczy:
			chapczy = true
			nanimator.play(&"Chaparka")
			await nanimator.animation_finished
			chapczy = false
