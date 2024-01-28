extends RigidBody2D

var composition := Color.GREEN
var total_nutrition := 10.0
var digestion_efficiency:= 0.0
var current_nutrition := 0.0

var digested := 1.0
var surface_level:= Vector2(0,50)
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player = $AudioStreamPlayer

var splashes = [preload("res://Audio/Water Splash 1.wav"), preload("res://Audio/Water Splash 2.wav"), preload("res://Audio/Water Splash 3.wav")]
var is_splash_played = false


func _ready():
	audio_stream_player.stream = splashes[randi()%3]
	audio_stream_player.pitch_scale = randf_range(0.8,1.2)
	sprite_2d.material.set_shader_parameter("digested", composition )
	#material = material.duplicate()
	angular_velocity = randf_range(-20,20)
	rotation = randf()*TAU
	sprite_2d.scale = Vector2(1.5,1.5)

func initialize(in_tex:Texture2D, in_efficiency:float, in_nutrition:float, in_composition:Color):
	$Sprite2D.texture = in_tex
	digestion_efficiency = in_efficiency
	total_nutrition = in_nutrition
	current_nutrition = in_nutrition
	composition = in_composition
	
	
func digest(acid:Color):
	#print(acid)
	var distance = max(max(abs(composition.r - acid.r), abs(composition.g - acid.g)),abs(composition.b - acid.b))
	var nutrition = max(1.0-distance, 0.0) * digestion_efficiency
	current_nutrition -= nutrition
	digested = current_nutrition/total_nutrition
	sprite_2d.material.set_shader_parameter("dissolve_value", digested )
	return nutrition

func _physics_process(delta):

	if position.y > surface_level.y:
		if not is_splash_played:
			is_splash_played = true
			audio_stream_player.play()
		var dist = position.y - surface_level.y
		apply_central_impulse(Vector2.UP*dist*2.0)
