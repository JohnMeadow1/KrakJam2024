extends RigidBody2D

var composition := Color.WHITE

@onready var sprite_2d = $Sprite2D

func _ready():
	material = material.duplicate()

func _process(delta):
	pass

#func get_digested(acid:Color):
	#composition.r -= acid
