extends ProgressBar

@onready var is_active := false

var tween: Tween
var swinging_player := G.Player

func _ready():
	for player in get_tree().get_nodes_in_group("Players"):
		if player.has_signal("start_swing"):
			player.connect("start_swing", _on_start_swing)


func _input(event):
	if not is_active:
		return

	if Input.is_action_just_pressed("Space"):
		print(value)
		is_active = false
		tween.kill()


func _process(delta):
	pass


func _on_start_swing(player: G.Player):
	is_active = true

	tween = create_tween()
	tween.tween_property(self, "value", 100, 1.0)
	tween.tween_property(self, "value", 0, 1.0)
	tween.tween_callback(_on_swing_cancel)


func _on_swing_cancel():
	print("CANCEL")
