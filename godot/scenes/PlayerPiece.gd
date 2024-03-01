extends Node3D
class_name PlayerPiece

signal clicked(node)

const SELECTED_MATERIAL := preload("res://assets/materials/selected.tres")
const ARROW_SCENE := preload("res://scenes/arrow.tscn")

@onready var mouse_is_hovering := false

func _ready():
	$pawn/StaticBody3D.connect("mouse_entered", _on_mouse_entered)
	$pawn/StaticBody3D.connect("mouse_exited", _on_mouse_exited)

func _unhandled_input(event):
	if mouse_is_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			clicked.emit(self)

func select():
	$pawn.set_surface_override_material(0, SELECTED_MATERIAL)
	$arrow.visible = true

func unselect():
	$pawn.set_surface_override_material(0, null)
	$arrow.visible = false

func _on_mouse_entered():
	mouse_is_hovering = true

func _on_mouse_exited():
	mouse_is_hovering = false
