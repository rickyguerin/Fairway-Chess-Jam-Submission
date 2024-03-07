class_name BlackPiece
extends RigidBody3D

signal moved
signal capture

const SELECTED_MATERIAL := preload("res://assets/materials/selected.tres")

@export var max_impulse := 24.0
@export var impulse_direction := Vector3(0, 0, -1)
@export var max_angle := 10.0
@export var allowed_directions: Array[float] = [0, -45, -90, -135, 180, 135, 90, 45]

@onready var is_selected := false


func _ready():
	connect("body_entered", _on_body_entered)


func _integrate_forces(state):
	if not is_selected:
		return

	is_selected = false

	var trans = state.get_transform()
	trans.basis = trans.basis.from_euler(Vector3(0, deg_to_rad(allowed_directions[0]), 0))
	state.set_transform(trans)


func select():
	$Mesh.material_override = SELECTED_MATERIAL
	$Arrow.visible = true


func unselect():
	$Mesh.material_override = null
	$Arrow.visible = false


func _on_body_entered(info):
	pass


func _should_clamp(value: float, base_angle: float) -> bool:
	if value >= base_angle - max_angle and value <= base_angle + max_angle:
		return false

	if base_angle == 180:
		if value >= -base_angle - max_angle and value <= -base_angle + max_angle:
			return false

	return true
