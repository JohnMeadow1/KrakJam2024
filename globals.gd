extends Node

var player:CharacterBody2D

func _ready() -> void:
	if OS.has_feature("editor"):
		get_window().mode = Window.MODE_WINDOWED
		get_window().size /= 2
		get_window().move_to_center()
