extends Control

@onready var pierdlicznik: TextureProgressBar = %Pierdlicznik

func _process(delta: float) -> void:
	pierdlicznik.value += 30 * delta # tymczasowe
	
	if Input.is_action_just_pressed("blokuj_pierd"):
		pierdlicznik.value -= 5
	
	if pierdlicznik.ratio > 0.9:
		owner.scena.pierd()
