class_name BlackPiece
extends RigidBody3D

signal moved
signal capture

const SELECTED_MATERIAL := preload("res://assets/materials/selected.tres")

@export var max_impulse := 24.0
@export var impulse_direction := Vector3(0, 0, -1)
@export var allowed_directions: Array[float] = [0, -45, -90, -135, 180, 135, 90, 45]

@onready var can_rotate := false


func _ready():
	connect("body_entered", _on_body_entered)


func _integrate_forces(state):
	if not can_rotate:
		return

	can_rotate = false

	var trans = state.get_transform()
	trans.basis = trans.basis.from_euler(Vector3(0, deg_to_rad(allowed_directions.pick_random()), 0))
	state.set_transform(trans)


func select():
	$Mesh.material_override = SELECTED_MATERIAL
	$Arrow.visible = true


func unselect():
	$Mesh.material_override = null
	$Arrow.visible = false


func _on_body_entered(info):
	pass
