extends RigidBody3D
class_name WhitePiece

signal clicked(node)
signal capture(attacker, defender)

const ROTATION_SPEED := 0.02
const SELECTED_MATERIAL := preload("res://assets/materials/selected.tres")

@export var max_impulse := 24.0
@export var impulse_direction := Vector3(0, 0, -1)
@export var max_angle := 10.0
@export var allowed_directions: Array[float] = [0, -45, -90, -135, 180, 135, 90, 45]

@onready var direction_index := 0
@onready var mouse_is_hovering := false
@onready var is_selected := false
@onready var reset_rotation := false

var rotation_direction := 0

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("body_entered", _on_body_entered)


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_is_hovering:
			clicked.emit(self)
		elif is_selected:
			clicked.emit(null)


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

	if reset_rotation:
		reset_rotation = false
		direction_index = 0
		trans.basis = trans.basis.from_euler(Vector3())

	elif Input.is_action_just_pressed("Q"):
		direction_index -= 1
		direction_index = posmod(direction_index, len(allowed_directions))
		trans.basis = trans.basis.from_euler(Vector3(0, deg_to_rad(allowed_directions[direction_index]), 0))

	elif Input.is_action_just_pressed("E"):
		direction_index += 1
		direction_index = posmod(direction_index, len(allowed_directions))
		trans.basis = trans.basis.from_euler(Vector3(0, deg_to_rad(allowed_directions[direction_index]), 0))

	elif Input.is_action_pressed("A") or Input.is_action_pressed("D"):
		var curr = trans.basis.get_euler().y
		var change = rotation_direction * ROTATION_SPEED

		if not _should_clamp(rad_to_deg(curr + change), allowed_directions[direction_index]):
			trans.basis = trans.basis.from_euler(Vector3(0, curr+change, 0))


	state.set_transform(trans)


func select():
	$Mesh.material_override = SELECTED_MATERIAL
	$Arrow.visible = true
	is_selected = true
	reset_rotation = true


func unselect():
	$Mesh.material_override = null
	$Arrow.visible = false
	is_selected = false


func swing():
	var d = (transform.basis * impulse_direction).normalized()
	apply_impulse(d * max_impulse)


func _on_mouse_entered():
	mouse_is_hovering = true


func _on_mouse_exited():
	mouse_is_hovering = false


func _on_body_entered(info):
	if (info.get_collision_layer() == 1):
		emit_signal("capture", self, info)


func _should_clamp(value: float, base_angle: float) -> bool:
	if value >= base_angle - max_angle and value <= base_angle + max_angle:
		return false

	if base_angle == 180:
		if value >= -base_angle - max_angle and value <= -base_angle + max_angle:
			return false

	return true
