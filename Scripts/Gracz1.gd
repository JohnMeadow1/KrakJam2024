extends Control

@onready var wstrzymator: TextureProgressBar = %Wstrzymator

var zaparcie: bool

func _process(delta: float) -> void:
	if not zaparcie and Input.is_action_pressed("blokuj_pierd"):
		owner.blokuje = true
		wstrzymator.value += 30 * delta
		if is_equal_approx(wstrzymator.ratio, 1.0):
			wstrzymator.modulate = Color.RED
			zaparcie = true
	else:
		owner.blokuje = false
		wstrzymator.value -= 10 * delta
		if zaparcie and wstrzymator.value < 80:
			zaparcie = false
			wstrzymator.modulate = Color.WHITE
