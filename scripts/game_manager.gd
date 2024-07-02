extends Node3D


func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
