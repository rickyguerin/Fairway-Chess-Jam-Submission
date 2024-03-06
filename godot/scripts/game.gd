extends Node

var selected_piece: Node3D
var can_act := true

func _ready():
	for child in $"White Pieces".get_children():
		child.connect("clicked", _select_piece)
		child.connect("capture", _unselect_all)
		child.connect("moved", _deactivate_pieces)


func _unselect_all():
	for child in $"White Pieces".get_children():
		(child as PlayerPiece).unselect()

	selected_piece = null


func _select_piece(node):
	if node is PlayerPiece and node != selected_piece and can_act:
		_unselect_all()
		node.select()
		selected_piece = node


func _deactivate_pieces():
	can_act = false
	_unselect_all()
