extends Node2D

var pressure := 0.0
var pressure_output := 0.0
var is_farting := false
var is_hungry := true

var pressure_gain_per_nutriotion = 0.05
var pressure_loss_to_farting = 0.0025

var blue_ratio:= 0.0
var green_ratio:= 0.0
var red_ratio:= 0.0
var nutrition:= 0.0

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
@onready var growl = $Growl
@onready var thoughts = $Thoughts


func _ready():
	spiner_blue.updated.connect(update_blue)
	spiner_green.updated.connect(update_green)
	spiner_red.updated.connect(update_red)
	
func add_food(tex:Texture2D, burn_efficiency:float, nutrition:float,  color:Color, name:String):
	var new_food = FOOD.instantiate()
	new_food.initialize(tex, burn_efficiency, nutrition,  color )
	new_food.position = %Marker2D.position
	%Stomanch2.add_child(new_food)
	food_array.append(new_food)
	
	var tekst:String = ""
	match name:
		"Biurwa":
			tekst = "whats this?"
		"TronKrólaSrania","TronKrólaSrania2","TuNieSrać":
			tekst = "WHY, JUST WHY?"
		"Plant","🌼2","🌼":
			tekst = "Mmmm, fiber!"
		"JakŻyć":
			tekst = "what?"
		"Bed":
			tekst = "HOW ???"
		"Stół","Stół2","Stół3":
			tekst = "NO!, God NO!"
		"Meat","Meat2":
			tekst = "Hey cutie"
		"Graczka":
			tekst = "'Przez żołądek do serca?', Thats what she said."
		"Apple","Apple2":
			tekst = "Friuts :)"
		"Plate","Plate2":
			tekst = "That is nice"
		"Piano":
			tekst = "🎶Wood🎵Metal🎶"
		_ when name.begins_with("Dude"):
			tekst = ["FRESH MEAT!","Looks like meats back on the menu boys!"].pick_random()
		_ when name.begins_with("Krzesło"):
			tekst = "_-_"
			
	if tekst.length()>0:
		thoughts.think(tekst)
	
	

func _physics_process(delta):
	digest()
	#pressure = 0.9

	
	acid = Color(0,%green.value/100,0) + Color(%red.value/100,0,0) + Color(0,0,%blue.value/100)
	stomanch.tint_progress.r = acid.r
	stomanch.tint_progress.g = acid.g
	stomanch.tint_progress.b = acid.b

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
	var resitance = get_pierdlicznik()/100.0
	pressure_output = pressure * (resitance)
	if is_farting:

		%Gas.tint_under = Color(1,1,1,0)
		%Gas.tint_progress = Color(1,1,1,1)
		%FartHole.emitting = true
		
		%FartHole.amount_ratio = pressure_output
		%FartHole.process_material.initial_velocity = Vector2(pressure_output*300, pressure_output*300+100)
		var force := (fart_hole.position.rotated(rigid_body_end.rotation) + Vector2(randf_range(-10,10),randf_range(-10,10))).normalized()
		var force_position = -fart_hole.position.rotated(rigid_body_end.rotation) + rigid_body_end.position
		rigid_body_end.apply_impulse(force * pressure_output*2.0, force_position)
		if is_instance_valid(Globals.player):
			Globals.player.fart(pressure_output, true)
		pressure -= pressure_output * pressure_loss_to_farting
	else:
		if is_instance_valid(Globals.player):
			Globals.player.fart(0.0, false)
		%Gas.tint_under = Color(1,1,1,1)
		%Gas.tint_progress = Color(1,1,1,0)
		%FartHole.emitting = false

	pressure_output *= float(is_farting)
	var pressure_sin = pressure_output*1.1
	#prints(pressure_sin,$AudioStreamPlayer1.volume_db)
	$AudioStreamPlayer1.volume_db = linear_to_db(cubicPulse(0.2,0.2,pressure_sin))
	$AudioStreamPlayer2.volume_db = linear_to_db(cubicPulse(0.3,0.25,pressure_sin))
	$AudioStreamPlayer3.volume_db = linear_to_db(cubicPulse(0.5,0.3,pressure_sin))
	$AudioStreamPlayer4.volume_db = linear_to_db(cubicPulse(0.7,0.25,pressure_sin))
	$AudioStreamPlayer5.volume_db = linear_to_db(cubicPulse(0.9,0.2,pressure_sin))

	
func cubicPulse( c:float, w:float, x:float )->float:
	x = abs(x - c)
	if x>w : return 0.0
	x /= w;
	return 1.0 - x*x*(3.0-2.0*x)

func digest():
	is_hungry = true
	for i in range(food_array.size(),0, -1):
		#print(i-1)
		nutrition += food_array[i-1].digest(acid)
		if food_array[i-1].digested <= 0:
			food_array[i-1].queue_free()
			food_array.remove_at(i-1)
	if nutrition>0:
		is_hungry = false
		pressure += nutrition * pressure_gain_per_nutriotion
		
	if is_hungry:
		if not growl.playing:
			growl.play()
	else:
		if growl.playing:
			growl.stop()


func update_blue():
	%blue.max = spiner_blue.value
	
func update_green():
	%green.max = spiner_green.value
	
func update_red():
	%red.max = spiner_red.value

func get_pierdlicznik() -> float:
	return owner.get_node(^"%Pierdlicznik").value
