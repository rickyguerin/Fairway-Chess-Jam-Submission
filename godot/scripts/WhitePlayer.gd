extends Node

signal select
signal unselect
signal start_swing(player)
signal turn_end(player)

@onready var can_act := false

var selected_piece: WhitePiece

func _ready():
	get_tree().root.get_child(0).connect("turn_start", _on_turn_start)
	for node in get_tree().get_nodes_in_group("WhitePieces"):
		node.connect("clicked", _select_piece)
		node.connect("capture", _on_capture)


func _input(event):
	if not (selected_piece and can_act):
		return

	if Input.is_action_just_pressed("Space"):
		can_act = false
		start_swing.emit(self)


func swing_accept(power_percent: float):
	print("ACCEPT " + str(power_percent))


func swing_cancel():
	can_act = true


func _on_turn_start(player: G.Player):
	if not player == G.Player.WHITE:
		return

	can_act = true


func _select_piece(node):
	if not node:
		_unselect_piece()

	elif node is WhitePiece and can_act:
		_unselect_piece()
		node.select()
		selected_piece = node
		select.emit()


func _unselect_piece():
	if selected_piece:
		selected_piece.unselect()
		selected_piece = null
		unselect.emit()


func _on_moved():
	can_act = false
	_unselect_piece()
	turn_end.emit(G.Player.WHITE)


func _on_capture(attacker: WhitePiece, defender: BlackPiece):
	if defender.name == "King":
		get_tree().change_scene_to_file("res://scenes/Victory.tscn")
