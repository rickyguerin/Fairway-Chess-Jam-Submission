extends Node


func _ready():
	get_tree().root.get_child(0).connect("turn_start", _on_turn_start)


func _on_turn_start(player: G.Player):
	if not player == G.Player.WHITE:
		return
	print("WHITE")
