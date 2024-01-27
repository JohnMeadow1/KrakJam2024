extends Node2D

var pressure := 0.0
var pressure_output := 0.0
var is_farting := false
var is_hungry := true

var pressure_gain_per_nutriotion = 0.05
var pressure_loss_to_farting = 0.01

var blue_ratio:= 0.0
var green_ratio:= 0.0
var red_ratio:= 0.0
var nutrition:=0.0

@onready var spiner_blue = $Sprite2D/SpinerBlue
@onready var spiner_green = $Sprite2D/SpinerGreen
@onready var spiner_red = $Sprite2D/SpinerRed
@onready var stomanch = %Stomanch

@onready var rigid_body_end:RigidBody2D = %RigidBodyEND
@onready var fart_hole:GPUParticles2D = %FartHole
@onready var line_2d = $Sprite2D/Line2D

var acid := Color.BLACK
var food_array = []
const FOOD = preload("res://Scenes/food.tscn")


func _ready():
	food_array.append($Sprite2D/Stomanch2/Food)
	spiner_blue.updated.connect(update_blue)
	spiner_green.updated.connect(update_green)
	spiner_red.updated.connect(update_red)
	
func add_food(tex:Texture2D, burn_efficiency:float, nutrition:float,  color:Color):
	var new_food = FOOD.instantiate()
	new_food.initialize(tex, burn_efficiency, nutrition,  color )
	new_food.position = %Marker2D.position
	%Stomanch2.add_child(new_food)
	food_array.append(new_food)

func _physics_process(delta):
	digest()
	
	var resitance = get_pierdlicznik()/100.0
	
	pressure_output = pressure * resitance
	
	acid = Color(0,%green.value/100,0) + Color(%red.value/100,0,0) + Color(0,0,%blue.value/100)
	stomanch.tint_progress = acid

	line_2d.points[3]=%PinJoint2D.to_local(%PinJoint2D2.global_position)
	line_2d.points[4]=%PinJoint2D.to_local(%RigidBody2D2.global_position)
	line_2d.points[5]=%PinJoint2D.to_local(%FartHole.global_position)

	if pressure >= 0.99:
		%Lever_base.toggle()
		
	if %Lever_base.is_forced and pressure < 0.75:
		%Lever_base.unblock()
	
	
	is_farting = false
	if %Lever_base.is_on:
		is_farting = true

	%Gas.tint_over = Color(0.741,0.79,0.371, pressure)
	#%Gas.tint_progress = Color(0.741,0.79,0.371, pressure)
	%Gas.scale.y = 0.3 + pressure * 0.5
	%Gas.scale.x = 0.5 + pressure * 0.1
	
	if is_farting:
		
		%Gas.tint_under = Color(1,1,1,0)
		%Gas.tint_progress = Color(1,1,1,1)
		%FartHole.emitting = true
		
		%FartHole.amount_ratio = pressure
		%FartHole.process_material.initial_velocity = Vector2(pressure*300, pressure*300+100)
		var force := (fart_hole.position.rotated(rigid_body_end.rotation) + Vector2(randf_range(-10,10),randf_range(-10,10))).normalized()
		var force_position = -fart_hole.position.rotated(rigid_body_end.rotation) + rigid_body_end.position
		rigid_body_end.apply_impulse(force * pressure*2.0, force_position)
		
		pressure -= pressure_output * pressure_loss_to_farting
	else:
		%Gas.tint_under = Color(1,1,1,1)
		%Gas.tint_progress = Color(1,1,1,0)
		%FartHole.emitting=false


func digest():
	
	is_hungry = true
	for i in range(food_array.size(),0, -1):
		#print(i-1)
		nutrition += food_array[i-1].digest(acid)
		if food_array[i-1].digested <= 0:
			food_array[i-1].queue_free()
			food_array.remove_at(i-1)
	if nutrition>0:
		pressure += nutrition * pressure_gain_per_nutriotion
		is_hungry = false

func update_blue():
	%blue.max = spiner_blue.value
	
func update_green():
	%green.max = spiner_green.value
	
func update_red():
	%red.max = spiner_red.value

func get_pierdlicznik() -> float:
	return owner.get_node(^"%Pierdlicznik").value
