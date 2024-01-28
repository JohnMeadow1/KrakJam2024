extends Node2D

var game
var blokgotokibel: bool

func wybrany_akcja(akcja: String):
	pass

func execute_pierd(pierd):
	pass

func pierd(f):
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

func apply_wstyd_dist(dist, f):
	var wst = f * 10000.0 / sqrt(dist)
	wst = minf(wst, 250)
	game.change_stat("shame", wst * get_physics_process_delta_time())
