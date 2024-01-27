extends Node2D

var is_blue_pressed:= false
var blue_ratio:= 0.0
var green_ratio:= 0.0
var red_ratio:= 0.0

var pressure := 10.0

@onready var spiner_blue = $Sprite2D/SpinerBlue
@onready var spiner_green = $Sprite2D/SpinerGreen
@onready var spiner_red = $Sprite2D/SpinerRed
@onready var stomanch = %Stomanch

@onready var rigid_body_end:RigidBody2D = %RigidBodyEND
@onready var fart_hole:GPUParticles2D = %FartHole
@onready var line_2d = $Sprite2D/Line2D

func _physics_process(delta):
	stomanch.tint_progress = Color(0,%blue.value/100,0) + Color(%red.value/100,0,0) +Color(0,0,%green.value/100)
	
	var force := (fart_hole.position.rotated(rigid_body_end.rotation)).normalized()
	var force_position = -fart_hole.position.rotated(rigid_body_end.rotation) + rigid_body_end.position
	rigid_body_end.apply_impulse(force * %red.value*0.02, force_position)


	line_2d.points[1]=%PinJoint2D.to_local(%PinJoint2D2.global_position)
	line_2d.points[2]=%PinJoint2D.to_local(%RigidBody2D2.global_position)
	line_2d.points[3]=%PinJoint2D.to_local(%FartHole.global_position)

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

	
