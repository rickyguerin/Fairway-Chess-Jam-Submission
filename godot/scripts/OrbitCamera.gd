extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		$InnerGimbal/Camera3D.translate(Vector3(0, 0, -1))

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		$InnerGimbal/Camera3D.translate(Vector3(0, 0, 1))

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.005)
			$InnerGimbal.rotate_x(-event.relative.y * 0.005)
			$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -PI/2, PI/2)
