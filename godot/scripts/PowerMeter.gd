extends ProgressBar

var tween: Tween
var swinging_player: Node

func _ready():
	for player in get_tree().get_nodes_in_group("Players"):
		if player.has_signal("start_swing"):
			player.connect("start_swing", _on_start_swing)


func _input(event):
	if not (tween and tween.is_running()):
		return

	if Input.is_action_just_pressed("Space"):
		tween.kill()
		_on_swing_accept()


func _on_start_swing(player):
	swinging_player = player

	tween = create_tween()
	tween.tween_property(self, "value", 100, 1.0)
	tween.tween_property(self, "value", 0, 1.0)
	tween.tween_callback(_on_swing_cancel)


func _on_swing_accept():
	if swinging_player.has_method("swing_accept"):
		swinging_player.swing_accept(value)

	swinging_player = null


func _on_swing_cancel():
	if swinging_player.has_method("swing_cancel"):
		swinging_player.swing_cancel()

	swinging_player = null
