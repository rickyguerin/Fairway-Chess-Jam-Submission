extends Node3D
class_name PlayerPiece

signal clicked(node)

const SELECTED_MATERIAL := preload("res://assets/materials/selected.tres")
const ARROW_SCENE := preload("res://scenes/arrow.tscn")

@onready var mouse_is_hovering := false
@onready var is_selected := false

func _ready():
	$"pawn-rigid".connect("mouse_entered", _on_mouse_entered)
	$"pawn-rigid".connect("mouse_exited", _on_mouse_exited)


func _physics_process(delta):
	if not is_selected:
		return

	if Input.is_action_pressed("A"):
		rotate_y(0.05)

	elif Input.is_action_pressed("D"):
		rotate_y(-0.05)


func _unhandled_input(event):
	if mouse_is_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			clicked.emit(self)


func select():
	$"pawn-rigid/pawn-rigid".set_surface_override_material(0, SELECTED_MATERIAL)
	$arrow.visible = true
	is_selected = true


func unselect():
	rotation = Vector3()
	$"pawn-rigid/pawn-rigid".set_surface_override_material(0, null)
	$arrow.visible = false
	is_selected = false


func _on_mouse_entered():
	mouse_is_hovering = true


func _on_mouse_exited():
	mouse_is_hovering = false
