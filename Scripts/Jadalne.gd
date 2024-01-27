@tool
extends Area2D

@export var sprite: Texture2D:
	set(s):
		sprite = s
		$Sprite2D.texture = s

@export var hunger_requirement: float
@export var color: Color

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Gracz":
		body.jadalne = self

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Gracz":
		body.jadalne = null

func can_eat() -> bool:
	return get_tree().current_scene.glood.value >= hunger_requirement

func zjedz():
	get_tree().current_scene.glood.value -= color.r * 50 # TODO
	queue_free()
