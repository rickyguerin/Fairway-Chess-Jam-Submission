extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	for player in get_tree().get_nodes_in_group("Players"):
		player.connect("start_swing", _on_start_swing)


func _on_start_swing():
	pass
