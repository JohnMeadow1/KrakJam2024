extends Control

@onready var pierdlicznik: TextureProgressBar = %Pierdlicznik
@onready var insides: Node2D = %RightSide

func _process(delta: float) -> void:
	if insides.is_farting:
		pierdlicznik.value += 25 * delta
	
	if Input.is_action_just_pressed("blokuj_pierd"):
		pierdlicznik.value -= 5
	
	if pierdlicznik.ratio > 0.9:
		owner.scena.pierd()
