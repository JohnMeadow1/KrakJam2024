extends Control

@onready var cukiers: MarginContainer = %Cukiers
@onready var fats: MarginContainer = %Fats
@onready var whites: MarginContainer = %Whites

@onready var strength: Range = %Strength
@onready var intelligence: Range = %Intelligence
@onready var shame: Range = %Shame

@onready var akcje_name: Label = %AkcjeName
@onready var true_scena: Control = %TrueScena
@onready var true_akcje: VBoxContainer = %TrueAkcje

var wyborydata: Dictionary

var scena: Node

func _ready() -> void:
	var t := TextDatabase.new()
	t.load_from_path("res://Resources/Wybory.cfg")
	wyborydata = t.get_dictionary()
	
	load_scena("ScenaFridge")

func load_scena(scenaname: String):
	if scena:
		scena.queue_free()
		scena = null
	
	scena = load("res://Scenes/%s.tscn" % scenaname).instantiate()
	scena.game = self
	true_scena.add_child(scena)

func set_wybory(wybory: String):
	for akcja in true_akcje.get_children():
		akcja.queue_free()
	
	if wybory.is_empty():
		return
	
	var wybo: Dictionary = wyborydata[wybory]
	akcje_name.text = wybo["header"]
	
	for i in 100:
		var akcja: String = wybo.get("opcja.%d" % i, "")
		if akcja.is_empty():
			break
		else:
			var button := Button.new()
			button.text = akcja
			true_akcje.add_child(button)
			button.pressed.connect(scena.wybrany_akcja.bind(akcja))

func change_stat(stat: String, value: float):
	match stat:
		"str":
			strength.value += value
		"int":
			intelligence.value += value
		"shame":
			shame.value += value
		"cukiers":
			cukiers.value += value
		"fats":
			fats.value += value
		"whites":
			whites.value += value
