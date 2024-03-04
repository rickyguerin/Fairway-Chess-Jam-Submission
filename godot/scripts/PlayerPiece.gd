extends RigidBody3D
class_name PlayerPiece

signal clicked(node)
signal capture

const SELECTED_MATERIAL := preload("res://assets/materials/selected.tres")

@export var max_impulse := 24.0
@export var impulse_direction := Vector3(0, 0, -1)

@export var max_angle := 10.0
@export var starting_directions: Array[float] = [0, 45, 90, 135, 180, 225, 270, 315]

@onready var mouse_is_hovering := false
@onready var is_selected := false

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("body_entered", _on_body_entered)


func _input(event):
	if mouse_is_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			clicked.emit(self)
			
	if is_selected and Input.is_action_just_pressed("Space") and linear_velocity.length() == 0:
		var d = (transform.basis * impulse_direction).normalized()
		apply_impulse(d * max_impulse)


func _physics_process(delta):
	# Prevent bug where sometimes pieces get "stuck" moving
	if linear_velocity.length() < 0.1:
		linear_velocity = Vector3()

	if not is_selected or linear_velocity.length() > 0:
		return

	if Input.is_action_pressed("A"):
		rotate_y(0.05)

	elif Input.is_action_pressed("D"):
		rotate_y(-0.05)

	rotation.y = clamp(rotation.y, -deg_to_rad(max_angle), deg_to_rad(max_angle))


func select():
	$Mesh.material_override = SELECTED_MATERIAL
	$Arrow.visible = true
	is_selected = true
	freeze = false


func unselect():
	rotation = Vector3()
	$Mesh.material_override = null
	$Arrow.visible = false
	is_selected = false
	freeze = true


func _on_mouse_entered():
	mouse_is_hovering = true


func _on_mouse_exited():
	mouse_is_hovering = false


func _on_body_entered(info):
	if (info.get_collision_layer() == 1):
		info.queue_free()
		emit_signal("capture")
