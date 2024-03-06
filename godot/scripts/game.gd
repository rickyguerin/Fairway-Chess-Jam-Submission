extends Node

signal turn_start(player)

func _ready():
	turn_start.emit(G.Player.WHITE)
