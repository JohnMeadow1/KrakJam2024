extends Node2D

var game
var blokgotokibel: bool

func wybrany_akcja(akcja: String):
	pass

func execute_pierd(pierd):
	pass

func pierd():
	pass

func goto_kibel(body: Node2D) -> void:
	if blokgotokibel or body.name != "Gracz":
		return
	
	game.gotokibel.call_deferred()

func return_from_kibel(body: Node2D) -> void:
	if body.name != "Gracz":
		return
	
	game.backfromthekibel.call_deferred()

func backfromkibelmoveplayer():
	pass
