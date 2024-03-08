extends Node

signal turn_end(player)

func _ready():
	get_tree().root.get_child(0).connect("turn_start", _on_turn_start)
	for node in get_tree().get_nodes_in_group("BlackPieces"):
		node.connect("capture", _on_capture)


func _on_turn_start(player: G.Player):
	if not player == G.Player.BLACK:
		return

	var piece: BlackPiece = get_tree().get_nodes_in_group("BlackPieces").pick_random()
	await get_tree().create_timer(1.0).timeout

	piece.select()
	await get_tree().create_timer(1.0).timeout

	piece.can_rotate = true
	await get_tree().create_timer(1.0).timeout

	piece.can_capture = true
	var d = (piece.transform.basis * piece.impulse_direction).normalized()
	piece.apply_impulse(d * piece.max_impulse)
	$Putt.pitch_scale = randf_range(0.8, 1.2)
	$Putt.play()
	await get_tree().create_timer(2.0).timeout
	piece.can_capture = false

	piece.unselect()
	_end_turn()


func _on_capture(attacker: BlackPiece, defender: WhitePiece):
	if defender.name == "King":
		get_tree().change_scene_to_file("res://scenes/Defeat.tscn")

	defender.queue_free()


func _end_turn():
	turn_end.emit(G.Player.BLACK)
