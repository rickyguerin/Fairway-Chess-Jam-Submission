extends Node

var selected_piece: Node3D

func _ready():
	for child in $"White Pieces".get_children():
		child.connect("clicked", _select_piece)


func _unselect_all():
	for child in $"White Pieces".get_children():
		(child as PlayerPiece).unselect()


func _select_piece(node):
	if node is PlayerPiece and node != selected_piece:
		_unselect_all()
		node.select()
		selected_piece = node
