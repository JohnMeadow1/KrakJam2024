@tool
extends Area2D

@export var sprite: Texture2D:
	set(s):
		sprite = s
		$Sprite2D.texture = s

@export var hunger_requirement: float
@export var color: Color

var prev_can_eat: bool

func _init() -> void:
	if not Engine.is_editor_hint():
		await tree_entered
		var miggertest := create_tween().set_loops()
		miggertest.tween_callback(test_mig).set_delay(0.4)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Gracz":
		body.jadalne = self

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Gracz":
		body.jadalne = null

func can_eat() -> bool:
	return get_tree().current_scene.glood.value >= hunger_requirement

func zjedz():
	get_tree().current_scene.insides.add_food($Sprite2D.texture, 0.1, 10.0, color)
	queue_free()

func test_mig():
	if can_eat() != prev_can_eat:
		prev_can_eat = can_eat()
	else:
		return
	
	if prev_can_eat:
		$Sprite2D.material = preload("res://Resources/Migeg.tres")
	else:
		$Sprite2D.material = null
