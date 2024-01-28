extends Node

@export var scena: String

func _ready() -> void:
	if not OS.has_feature("editor"):
		queue_free()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		owner.game.zrobione_sceny.append(scena)
		owner.game.load_scena("DasRaum")
	elif Input.is_key_pressed(KEY_2):
		owner.game.glood.value += 0.5
