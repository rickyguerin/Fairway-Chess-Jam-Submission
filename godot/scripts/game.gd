extends Node

signal turn_start(player)

func _ready():
	$WhitePlayer.connect("turn_end", _on_turn_end)
	$BlackPlayer.connect("turn_end", _on_turn_end)
	turn_start.emit(G.Player.WHITE)


func _on_turn_end(player: G.Player):
	if player == G.Player.WHITE:
		turn_start.emit(G.Player.BLACK)
	else:
		turn_start.emit(G.Player.WHITE)
