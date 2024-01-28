@tool
extends Area2D

@export var sprite: Texture2D:
	set(s):
		sprite = s
		$Sprite2D.texture = s
		

@export var hunger_requirement: float
@export var color: Color
@export var burn_efficiency: float = 0.1
@export var nutrition: float = 10.0
@export var is_colliding: bool = false
@export var extra_offset: Vector2:
	set(s):
		extra_offset = s
		$Sprite2D.offset.y = s.y
		$Sprite2D.offset.x = s.x

var prev_can_eat: bool

func _ready():
	if not is_colliding and not Engine.is_editor_hint():
		if has_node("StaticBody2D"):
			$StaticBody2D.queue_free()
	
	if not has_node("Sprite2D"):
		return
	
	$Sprite2D.offset.y = -$Sprite2D.get_rect().size.y*0.5 + extra_offset.y
	$Sprite2D.offset.x = extra_offset.x

func _init() -> void:
	if not Engine.is_editor_hint():
		await tree_entered
		var miggertest := create_tween().set_loops()
		miggertest.tween_callback(test_mig).set_delay(0.4)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Gracz":
		body.jadalne.append(self)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Gracz":
		body.jadalne.erase(self)

func can_eat() -> bool:
	return get_tree().current_scene.glood.value >= hunger_requirement

func zjedz():
	get_tree().current_scene.insides.add_food($Sprite2D.texture, burn_efficiency, nutrition, color, name)
	queue_free()

func test_mig():
	if can_eat() != prev_can_eat:
		prev_can_eat = can_eat()
	else:
		return
	
	if not has_node("Sprite2D"):
		return
	
	if prev_can_eat:
		$Sprite2D.material = preload("res://Resources/Migeg.tres")
	else:
		$Sprite2D.material = null
