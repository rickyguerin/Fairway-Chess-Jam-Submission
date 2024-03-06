extends Node

signal turn_end(player)

func _ready():
	get_tree().root.get_child(0).connect("turn_start", _on_turn_start)


func _on_turn_start(player: G.Player):
	if not player == G.Player.BLACK:
		return

	print("BLACK")
	_end_turn()


func _end_turn():
	turn_end.emit(G.Player.BLACK)
