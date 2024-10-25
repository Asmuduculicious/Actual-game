extends Node2D

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/LevelSelection.tscn")

# Going to level selection scene

func _on_button_2_pressed():
	get_tree().quit()

# Quitting the game
