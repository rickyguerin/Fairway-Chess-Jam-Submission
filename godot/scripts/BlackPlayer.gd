extends Node

signal turn_end(player)

@onready var pieces: Array[BlackPiece] = []

func _ready():
	for node in get_tree().get_nodes_in_group("BlackPieces"):
		pieces.append(node)

	get_tree().root.get_child(0).connect("turn_start", _on_turn_start)


func _on_turn_start(player: G.Player):
	if not player == G.Player.BLACK:
		return

	var piece: BlackPiece = pieces.pick_random()
	await get_tree().create_timer(1.0).timeout

	piece.select()
	await get_tree().create_timer(1.0).timeout

	piece.can_rotate = true
	await get_tree().create_timer(1.0).timeout

	var d = (piece.transform.basis * piece.impulse_direction).normalized()
	piece.apply_impulse(d * piece.max_impulse)
	$Putt.pitch_scale = randf_range(0.8, 1.2)
	$Putt.play()
	await get_tree().create_timer(1.0).timeout

	piece.unselect()
	_end_turn()


func _end_turn():
	turn_end.emit(G.Player.BLACK)
