extends ProgressBar


func _ready():
	for player in get_tree().get_nodes_in_group("Players"):
		if player.has_signal("start_swing"):
			player.connect("start_swing", _on_start_swing)


func _process(delta):
	pass


func _on_start_swing(player: G.Player):
	var tween = create_tween()

	tween.tween_property(self, "value", 100, 1.0)
	tween.tween_property(self, "value", 0, 1.0)
