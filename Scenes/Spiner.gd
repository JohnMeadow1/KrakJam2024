extends Node2D

@export var texture:Texture

var is_pressed := false
var previous_mouse_position := Vector2.ZERO
var value = 50.0

@onready var button = $Button
signal updated

func _ready():
	button.texture_normal = texture
	button.pivot_offset = texture.get_size() * 0.5
	button.position = -button.pivot_offset
	set_physics_process(false)

func _physics_process(delta):
	var angle_difference = atan2(previous_mouse_position.cross(get_local_mouse_position()), previous_mouse_position.dot(get_local_mouse_position()) )
	previous_mouse_position = get_local_mouse_position()
	value += angle_difference *2.0
	value = clamp(value, 0.0, 100.0)
	button.rotation = value / 2.0
	updated.emit()


func _on_button_down():
	set_physics_process(true)
	previous_mouse_position = get_local_mouse_position()
	is_pressed = true


func _on_button_up():
	set_physics_process(false)
	is_pressed = false
