extends Node3D

@onready var HOVER_MATERIAL = preload("res://assets/materials/piece_hover.tres")


func _ready():
	$pawn/StaticBody3D.connect("mouse_entered", _on_mouse_entered)
	$pawn/StaticBody3D.connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	$pawn.set_surface_override_material(0, HOVER_MATERIAL)

func _on_mouse_exited():
	$pawn.set_surface_override_material(0, null)
