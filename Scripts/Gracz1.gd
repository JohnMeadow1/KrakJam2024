extends Control

@onready var pierdlicznik: TextureProgressBar = %Pierdlicznik
@onready var insides: Node2D = %RightSide

func _physics_process(delta: float) -> void:
	if insides.is_farting:
		pierdlicznik.value += insides.pressure * 10 * delta
		owner.scena.pierd(insides.pressure_output)
		#print(insides.pressure_output)
	
	if Input.is_action_just_pressed("blokuj_pierd"):
		pierdlicznik.value -= 5
