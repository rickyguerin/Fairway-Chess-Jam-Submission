extends Node

signal turn_end(player)

var _white_pieces: Dictionary
var _black_pieces: Dictionary

var _attack_piece: BlackPiece
var _attack_angle: float

func _ready():
	get_tree().root.get_child(0).connect("turn_start", _on_turn_start)
	for node in get_tree().get_nodes_in_group("BlackPieces"):
		node.connect("capture", _on_capture)
		_black_pieces[node.name] = node

	for node in get_tree().get_nodes_in_group("WhitePieces"):
		_white_pieces[node.name] = node


func _on_turn_start(player: G.Player):
	if not player == G.Player.BLACK:
		return

	await get_tree().create_timer(4.0).timeout
	_pick_piece_to_move()

	_attack_piece.select()
	_attack_piece.can_rotate = true
	await get_tree().create_timer(1.0).timeout

	_attack_piece.can_capture = true
	var d = (_attack_piece.transform.basis * _attack_piece.impulse_direction).normalized()
	_attack_piece.apply_impulse(d * _attack_piece.max_impulse)
	$Putt.pitch_scale = randf_range(0.8, 1.2)
	$Putt.play()
	await get_tree().create_timer(2.0).timeout
	_attack_piece.can_capture = false

	_attack_piece.unselect()
	_end_turn()


func _on_capture(attacker: BlackPiece, defender: WhitePiece):
	if defender.name == "King":
		get_tree().change_scene_to_file("res://scenes/Defeat.tscn")

	defender.queue_free()


func _end_turn():
	turn_end.emit(G.Player.BLACK)


func _pick_piece_to_move():
	var white_attacks := {}
	var black_attacks := {}

	for bp in get_tree().get_nodes_in_group("BlackPieces"):
		for wp in get_tree().get_nodes_in_group("WhitePieces"):
			if G.can_attack(wp, bp):
				if white_attacks.has(wp.name):
					white_attacks[wp.name].append(bp)
				else:
					white_attacks[wp.name] = [bp]

			if G.can_attack(bp, wp):
				if black_attacks.has(bp.name):
					black_attacks[bp.name].append(wp)
				else:
					black_attacks[bp.name] = [wp]

	var white_attacker_names := []
	var black_attacker_names := []
	var targets := []

	for key in white_attacks.keys():
		for piece in white_attacks[key]:
			if piece.name == "King":
				white_attacker_names.append(key)

	if len(white_attacker_names) == 0:
		if len(black_attacks.keys()) > 0:
			_most_valuable_capture(black_attacks)

		else:
			_attack_piece = get_tree().get_nodes_in_group("BlackPieces").pick_random()
			_attack_piece.attack_angle = _attack_piece.allowed_directions[0]

		return

	if len(black_attacks.keys()) == 0:
		_attack_piece = get_tree().get_nodes_in_group("BlackPieces").pick_random()
		_attack_piece.attack_angle = _attack_piece.allowed_directions[0]
		return

	for key in black_attacks.keys():
		for piece in black_attacks[key]:
			if white_attacker_names.has(piece.name):
				targets.append(piece.name)
				black_attacker_names.append(key)

	if len(targets) == 0:
		_attack_piece = get_tree().get_nodes_in_group("BlackPieces").pick_random()
		_attack_piece.attack_angle = _attack_piece.allowed_directions[0]
		return

	var target = _closest_to_king(targets)
	var attacker = _closest_to_target(target, black_attacker_names)

	_attack_piece =  _black_pieces[attacker]
	
	var ang = G.can_attack(_attack_piece, _white_pieces[target])
	if ang:
		_attack_piece.attack_angle = ang
	else:
		_attack_piece.attack_angle = _attack_piece.allowed_directions[0]

func _closest_to_king(names: Array) -> String:
	var king: BlackPiece = _black_pieces["King"]
	var closest_distance = 999
	var closest_piece = null

	for name in names:
		var white_piece: WhitePiece = _white_pieces[name]
		var distance = king.position.distance_to(white_piece.position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_piece = white_piece

	return closest_piece.name if closest_piece else ""


func _closest_to_target(target_name: String, attacker_names: Array) -> String:
	var target: WhitePiece = _white_pieces[target_name] 
	var closest_distance = 999
	var closest_piece = null

	for name in attacker_names:
		var black_piece: BlackPiece = _black_pieces[name]
		var distance = black_piece.position.distance_to(target.position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_piece = black_piece

	return closest_piece.name


func _most_valuable_capture(black_attacks: Dictionary):
	var highest_value := 0
	var attacker_name := ""
	var attacker_distance := 999
	var defender_name := ""
	
	for key in black_attacks.keys():
		for piece in black_attacks[key]:
			var dist = piece.position.distance_to(_black_pieces[key].position)
			if G.piece_value(piece) > highest_value:
				highest_value = G.piece_value(piece)
				attacker_name = key
				attacker_distance = piece.position.distance_to(_black_pieces[key].position)
				defender_name = piece.name

			elif G.piece_value(piece) == highest_value:
				pass

	_attack_piece = _black_pieces[attacker_name]
	var ang = G.can_attack(_attack_piece, _white_pieces[defender_name])
	if ang:
		_attack_piece.attack_angle = ang
	else:
		_attack_piece.attack_angle = _attack_piece.allowed_directions[0]
