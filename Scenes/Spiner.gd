extends Node2D

@export var texture:Texture
@export var lastvalveposition: float

var is_pressed := false
var previous_mouse_position := Vector2.ZERO
var value := 50.0
var playing: float

@onready var button = $Button
signal updated

func _ready():
	button.texture_normal = texture
	button.pivot_offset = texture.get_size() * 0.5
	button.position = -button.pivot_offset
	get_tree().create_timer(0.2).timeout.connect(func(): $AudioStreamPlayer2D.stream_paused = true) # aka call_super_fking_deferred()
	set_physics_process(false)

func _physics_process(delta):
	var angle_difference = atan2(previous_mouse_position.cross(get_local_mouse_position()), previous_mouse_position.dot(get_local_mouse_position()) )
	previous_mouse_position = get_local_mouse_position()
	var prev := value
	value += angle_difference *2.0
	value = clamp(value, 0.0, 100.0)
	button.rotation = value / 2.0
	updated.emit()
	
	if not is_equal_approx(value, prev):
		playing = 0.2
	
	$AudioStreamPlayer2D.stream_paused = playing <= 0
	playing -= delta

func _on_button_down():
	set_physics_process(true)
	previous_mouse_position = get_local_mouse_position()
	is_pressed = true
	#$AudioStreamPlayer2D.seek(lastvalveposition)
 
func _on_button_up():
	set_physics_process(false)
	is_pressed = false
	$AudioStreamPlayer2D.stream_paused = true
	playing = 0
