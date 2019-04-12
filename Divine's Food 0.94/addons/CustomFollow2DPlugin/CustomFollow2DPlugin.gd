tool
extends EditorPlugin
#res://addons/CustomFollow2DPlugin/
#res://addons/CustomFollow2DPlugin/

func _enter_tree():
	add_custom_type("CustomFollow2D", "PathFollow2D", preload("Follow.tscn"), preload("snake.png"))

func _exit_tree():
	remove_custom_type("CustomFollow2D")