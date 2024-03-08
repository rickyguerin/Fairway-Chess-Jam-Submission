extends AudioStreamPlayer

@onready var is_active := false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_active:
		is_active = true
		var tween = create_tween()
		tween.tween_property(self, "volume_db", -24, randi_range(4, 30))
		tween.tween_property(self, "volume_db", -36, randi_range(4, 30))
		tween.tween_callback(_deactivate)


func _deactivate():
	is_active = false
