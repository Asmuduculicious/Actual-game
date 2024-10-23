extends Node2D

@onready var global = get_node("/root/global")

func _on_button_pressed():
	if global.current_level == "Tutorial":
		get_tree().change_scene_to_file("res://scene/Tutorial.tscn")
	if global.current_level == "Level_1":
		get_tree().change_scene_to_file("res://scene/Level1.tscn")
	if global.current_level == "Level_2":
		get_tree().change_scene_to_file("res://scene/Level2.tscn")
	if global.current_level == "Level_3":
		get_tree().change_scene_to_file("res://scene/Level3.tscn")
	if global.current_level == "Level_4":
		get_tree().change_scene_to_file("res://scene/Level4.tscn")
	if global.current_level == "Level_5":
		get_tree().change_scene_to_file("res://scene/Level5.tscn")
