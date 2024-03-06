extends Node

signal turn_end(player)

@onready var can_act := false

var selected_piece: PlayerPiece

func _ready():
	get_tree().root.get_child(0).connect("turn_start", _on_turn_start)
	for node in get_tree().get_nodes_in_group("WhitePieces"):
		node.connect("clicked", _select_piece)
		node.connect("moved", _on_moved)


func _on_turn_start(player: G.Player):
	if not player == G.Player.WHITE:
		return

	can_act = true


func _select_piece(node):
	if node is PlayerPiece and node != selected_piece and can_act:
		_unselect_piece()
		node.select()
		selected_piece = node


func _unselect_piece():
	if selected_piece:
		selected_piece.unselect()

	selected_piece = null


func _on_moved():
	can_act = false
	_unselect_piece()
	turn_end.emit(G.Player.WHITE)
