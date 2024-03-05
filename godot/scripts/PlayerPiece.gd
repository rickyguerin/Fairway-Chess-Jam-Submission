extends RigidBody3D
class_name PlayerPiece

signal clicked(node)
signal capture

const ROTATION_SPEED := 1.5
const SELECTED_MATERIAL := preload("res://assets/materials/selected.tres")

@export var max_impulse := 24.0
@export var impulse_direction := Vector3(0, 0, -1)
@export var max_angle := 10.0
@export var allowed_directions: Array[Vector3] = [
	Vector3.FORWARD,
	Vector3.FORWARD + Vector3.RIGHT,
	Vector3.RIGHT,
	Vector3.RIGHT + Vector3.BACK,
	Vector3.BACK,
	Vector3.BACK + Vector3.LEFT,
	Vector3.LEFT,
	Vector3.LEFT + Vector3.FORWARD,
]

@onready var direction_index := 0
@onready var mouse_is_hovering := false
@onready var is_selected := false

var rotation_direction := 0

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("body_entered", _on_body_entered)


func _input(event):
	if mouse_is_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			clicked.emit(self)
			return

	if not is_selected:
		return

	if Input.is_action_just_pressed("Space"):
		var d = (transform.basis * impulse_direction).normalized()
		apply_impulse(d * max_impulse)


func _process(delta):
	rotation_direction = 0
	
	if is_selected:
		if Input.is_action_pressed("A"):
			rotation_direction = 1
		elif Input.is_action_pressed("D"):
			rotation_direction = -1


func _integrate_forces(state):
	if not is_selected:
		return

	var trans = state.get_transform()

	if Input.is_action_just_pressed("Q"):
		direction_index -= 1
		direction_index = posmod(direction_index, len(allowed_directions))
		trans = trans.looking_at(trans.origin + allowed_directions[direction_index])

	if Input.is_action_just_pressed("E"):
		direction_index += 1
		direction_index = posmod(direction_index, len(allowed_directions))
		trans = trans.looking_at(trans.origin + allowed_directions[direction_index])

	trans = trans.rotated_local(Vector3.UP, deg_to_rad(rotation_direction * ROTATION_SPEED))
	state.set_transform(trans)


func select():
	$Mesh.material_override = SELECTED_MATERIAL
	$Arrow.visible = true
	is_selected = true


func unselect():
	$Mesh.material_override = null
	$Arrow.visible = false
	is_selected = false


func _on_mouse_entered():
	mouse_is_hovering = true


func _on_mouse_exited():
	mouse_is_hovering = false


func _on_body_entered(info):
	if (info.get_collision_layer() == 1):
		info.queue_free()
		emit_signal("capture")
