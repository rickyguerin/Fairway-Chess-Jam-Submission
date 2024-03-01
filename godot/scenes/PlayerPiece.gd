extends Node3D


func _ready():
	$pawn/StaticBody3D.connect("mouse_entered", _on_mouse_entered)
	$pawn/StaticBody3D.connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	print("ENTER " + get_name())

func _on_mouse_exited():
	print("EXIT " + get_name())
