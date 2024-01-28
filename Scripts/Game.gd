extends Control

@onready var cukiers: MarginContainer = %RightSide.get_node("%blue")
@onready var fats: MarginContainer = %RightSide.get_node("%green")
@onready var whites: MarginContainer = %RightSide.get_node("%red")

@onready var strength: Range = %Strength
@onready var intelligence: Range = %Intelligence
@onready var shame: Range = %Shame
@onready var glood: TextureProgressBar = %Glood
@onready var dodaj_glood: Label = %DodajGlood

@onready var akcje_name: Label = %AkcjeName
@onready var true_scena: Control = %TrueScena
@onready var true_akcje: VBoxContainer = %TrueAkcje

@onready var insides: Node2D = %RightSide

var wyborydata: Dictionary
var zrobione_sceny: Array[String]

var scena: Node
var KIBEL: Node
var blokuje: float

func _ready() -> void:
	var t := TextDatabase.new()
	t.load_from_path("res://Resources/Wybory.cfg")
	wyborydata = t.get_dictionary()
	
	load_scena("DasRaum")

func load_scena(scenaname: String):
	if scenaname in zrobione_sceny:
		return
	
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
		akcje_name.text = ""
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
			show_dodaj(%DodajStrength, value)
		"int":
			intelligence.value += value
			show_dodaj(%DodajInteligencja, value)
		"shame":
			if is_equal_approx(shame.ratio, 1.0):
				get_tree().change_scene_to_file("res://Scenes/GejMover.tscn")
				return
			
			shame.value += value
			show_dodaj(%DodajWstyd, value)
		"cukiers":
			cukiers.value += value
		"fats":
			fats.value += value
		"whites":
			whites.value += value

func execute_pierd():
	if blokuje:
		# info?
		return
	
	var pierd := Pierd.new()
	pierd.volume = cukiers.pick - whites.pick
	pierd.stink = fats.pick + whites.pick
	pierd.length = whites.pick - cukiers.pick
	
	cukiers.value -= cukiers.pick * 0.1
	fats.value -= fats.pick * 0.1
	whites.value -= whites.pick * 0.1
	
	var gruzarka: float = cukiers.pick + fats.pick + whites.pick
	pierd.with_gruz = gruzarka > 70 and gruzarka < 110
	
	name_pierd(pierd)
	scena.execute_pierd(pierd)

func name_pierd(pierd: Pierd):
	var nazwa: PackedStringArray
	
	if pierd.volume > 70:
		nazwa.append("Kilotonowy")
	elif pierd.volume > 40:
		nazwa.append("Głośny")
	
	if pierd.stink < 20:
		if pierd.volume < 20:
			nazwa.append("Cichacz")
		else:
			nazwa.append("Pierduś")
	elif pierd.stink > 70:
		if pierd.volume < 20:
			nazwa.append("Cichacz Morderca")
		else:
			nazwa.append("Pierd Morderca")
	else:
		nazwa.append("Pierd")
	
	if pierd.length < 20 and pierd.stink < 20:
		nazwa.append("Ulotnego Aromatu")
	elif pierd.length < 50:
		nazwa.append("Chwili Konsternacji")
	elif pierd.length > 80:
		nazwa.append("Wiecznego Smrodu")
	
	if pierd.with_gruz:
		nazwa.append("z gruzem")
	
	%PierdName.text = " ".join(nazwa)

func show_dodaj(dodaj: Label, value: int):
	if value > 0:
		dodaj.text = str("+", value)
	elif value < 0:
		dodaj.text = str("-", value)
	else:
		return
	
	var tween := create_tween()
	tween.tween_callback(dodaj.set_text.bind("")).set_delay(2)

class Pierd:
	var volume: float
	var stink: float
	var length: float
	var with_gruz: bool
	
	func _to_string() -> String:
		return "volume %f stink %f length %f gruz? %s" % [volume, stink, length, with_gruz]

func _physics_process(delta: float) -> void:
	if insides.is_hungry:
		glood.value += 2 * delta
	else:
		glood.value -= insides.nutrition
		insides.nutrition = 0.0
	
	if is_instance_valid(Globals.player):
		Globals.player.czompers.scale.y = glood.value/400.0
	
	if OS.has_feature("editor"): return
	if is_equal_approx(glood.ratio, 1.0):
		get_tree().change_scene_to_file("res://Scenes/Gej2Mover.tscn")

func gotokibel():
	true_scena.remove_child(scena)
	
	KIBEL = load("res://Scenes/Kibel.tscn").instantiate()
	KIBEL.game = self
	true_scena.add_child(KIBEL)
	AudioServer.set_bus_effect_enabled(0, 0, true)


func backfromthekibel():
	scena.blokgotokibel = true
	true_scena.add_child(scena)
	scena.backfromkibelmoveplayer()
	AudioServer.set_bus_effect_enabled(0, 0, false)
	
	KIBEL.queue_free()
	await get_tree().physics_frame
	scena.blokgotokibel = false
