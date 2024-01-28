extends CharacterBody2D

@onready var how_to_play: Label = $Label
@onready var how_to_devour: Label = $Label2
@onready var nanimator: AnimationPlayer = $AnimationPlayer
@onready var nanimator_2 = $AnimationPlayer2

@onready var pragnienieniemaszansz_2d: Sprite2D = $Sprite2D

var jadalne: Array
var praktik

var chapczy: bool
@onready var fart_hole = %FartHole
@onready var czompers = $Sprite2D/Zembs2

var fart_force:= Vector2.ZERO
var hit_the_deck := false

func _enter_tree() -> void:
	Globals.player = self

func fart(pressure_output:float, is_emiting:bool):
	hit_the_deck = false
	
	fart_hole.emitting = is_emiting
	fart_hole.amount_ratio = pressure_output
	fart_hole.process_material.initial_velocity = Vector2(pressure_output*100, pressure_output*100+100)
	if pressure_output>0.5:
		hit_the_deck = true
		var v2 = Vector2.DOWN.rotated(randf_range(-0.4,0.4))
		fart_hole.process_material.direction = Vector3(v2.x,v2.y,0)
		fart_force = -v2.rotated(PI*0.5) * pressure_output*3*pragnienieniemaszansz_2d.scale.x
	else:
		var v2 = Vector2.DOWN.rotated(randf_range(-0.8,0.8))
		fart_hole.process_material.direction = Vector3(v2.x,v2.y,0)
	
		fart_force = -v2.rotated(PI*0.5) * pressure_output*3*pragnienieniemaszansz_2d.scale.x

func reset():
	%Sprite2D.rotation = 0.0
	fart_force = Vector2.ZERO
	velocity = Vector2.ZERO
	fart_hole.amount_ratio = 0

func _physics_process(delta: float) -> void:
	if hit_the_deck:
		%Sprite2D.rotation = lerp(%Sprite2D.rotation, PI*0.5*pragnienieniemaszansz_2d.scale.x, 0.25)
		pragnienieniemaszansz_2d.position = lerp(pragnienieniemaszansz_2d.position,Vector2(0,0),0.25)
	else:
		%Sprite2D.rotation = lerp(%Sprite2D.rotation, 0.0, 0.25)
		pragnienieniemaszansz_2d.position = lerp(pragnienieniemaszansz_2d.position,Vector2(0,-75),0.25)
		var move := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = move * 300 
	position += fart_force
	move_and_slide()
	
	scale = Vector2.ONE + Vector2((position.y - 480)/600,(position.y - 480)/600)
	
	#if not chapczy:
	if velocity.is_zero_approx():
		if hit_the_deck:
			nanimator.play(&"Swing")
		else:
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
		
		#if not chapczy:
			#chapczy = true
		nanimator_2.play(&"Chaparka")
			#await nanimator.animation_finished
			#chapczy = false
