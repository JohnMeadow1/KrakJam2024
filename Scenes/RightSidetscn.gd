extends Node2D

var pressure := 1.0
var is_farting:= false

var blue_ratio:= 0.0
var green_ratio:= 0.0
var red_ratio:= 0.0

@onready var spiner_blue = $Sprite2D/SpinerBlue
@onready var spiner_green = $Sprite2D/SpinerGreen
@onready var spiner_red = $Sprite2D/SpinerRed
@onready var stomanch = %Stomanch

@onready var rigid_body_end:RigidBody2D = %RigidBodyEND
@onready var fart_hole:GPUParticles2D = %FartHole
@onready var line_2d = $Sprite2D/Line2D

var acid :=Color.BLACK
var timer:=0.0
func _physics_process(delta):
	timer +=delta*0.5
	pressure = sin(timer)*0.5+0.5
	
	
	acid = Color(0,%blue.value/100,0) + Color(%red.value/100,0,0) +Color(0,0,%green.value/100)
	stomanch.tint_progress = acid

	line_2d.points[3]=%PinJoint2D.to_local(%PinJoint2D2.global_position)
	line_2d.points[4]=%PinJoint2D.to_local(%RigidBody2D2.global_position)
	line_2d.points[5]=%PinJoint2D.to_local(%FartHole.global_position)

	if pressure >= 0.99:
		%Lever_base.toggle()
		
	is_farting = false
	if %Lever_base.is_on:
		is_farting = true


	%Gas.tint_over = Color(0.741,0.79,0.371, pressure)
	#%Gas.tint_progress = Color(0.741,0.79,0.371, pressure)
	%Gas.scale.y = 0.3 + pressure * 0.5
	%Gas.scale.x = 0.5 + pressure * 0.1
	
	if is_farting:
		%Gas.tint_under = Color(1,1,1,0)
		%FartHole.emitting = true
		%FartHole.amount_ratio = pressure
		%FartHole.process_material.initial_velocity = Vector2(pressure*300, pressure*300+100)
		var force := (fart_hole.position.rotated(rigid_body_end.rotation) + Vector2(randf_range(-10,10),randf_range(-10,10))).normalized()
		var force_position = -fart_hole.position.rotated(rigid_body_end.rotation) + rigid_body_end.position
		rigid_body_end.apply_impulse(force * pressure*2.0, force_position)
	else:
		%Gas.tint_under = Color(1,1,1,1)
		%FartHole.emitting=false

func _ready():
	spiner_blue.updated.connect(update_blue)
	spiner_green.updated.connect(update_green)
	spiner_red.updated.connect(update_red)

func update_blue():
	%blue.max = spiner_blue.value
	
func update_green():
	%green.max = spiner_green.value
	
func update_red():
	%red.max = spiner_red.value
