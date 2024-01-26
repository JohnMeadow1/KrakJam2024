extends Control

var paski: Array[Control]
var selected_pasek: int

func _ready() -> void:
	paski.assign(get_tree().get_nodes_in_group("paski"))
	update_wybrany_pasek()

func _process(delta: float) -> void:
	if selected_pasek < paski.size() - 1 and Input.is_action_just_pressed("pasek_next"):
		selected_pasek += 1
		update_wybrany_pasek()
	elif selected_pasek > 0 and Input.is_action_just_pressed("pasek_poprzedni"):
		selected_pasek -= 1
		update_wybrany_pasek()
	elif Input.is_action_pressed("more_pasek"):
		paski[selected_pasek].increase()
	elif Input.is_action_pressed("less_pasek"):
		paski[selected_pasek].decrease()
	elif Input.is_action_just_pressed("akcja"):
		owner.execute_pierd()

func update_wybrany_pasek():
	for i in paski.size():
		paski[i].set_selected(i == selected_pasek)
