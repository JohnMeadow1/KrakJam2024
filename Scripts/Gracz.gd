extends CharacterBody2D

@onready var how_to_play: Label = $Label
@onready var how_to_devour: Label = $Label2
@onready var nanimator: AnimationPlayer = $AnimationPlayer
@onready var pragnienieniemaszansz_2d: Sprite2D = $Sprite2D

var jadalne: Array
var praktik

var chapczy: bool
@onready var fart_hole = %FartHole

var fart_force:= Vector2.ZERO
func _ready():
	Globals.player = self

func fart(pressure_output:float, is_emiting:bool):
	fart_hole.emitting = is_emiting
	fart_hole.amount_ratio = pressure_output
	fart_hole.process_material.initial_velocity = Vector2(pressure_output*100, pressure_output*100+100)
	var v2 = Vector2.DOWN.rotated(randf_range(-0.8,0.8))
	fart_hole.process_material.direction = Vector3(v2.x,v2.y,0)
	
	fart_force = -v2.rotated(PI*0.5) * pressure_output*300*pragnienieniemaszansz_2d.scale.x


func _physics_process(delta: float) -> void:
	var move := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move * 300 + fart_force
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
