extends Node2D

func _ready():
	$Area2D.visible = false
	$Button4.visible = true
	
# This panel is directly inserted in the player scene, so at the start it will hide itself
# However, the pause button isn't under the Area2D and therefore will still be seen so that the player can click it

func _process(delta):
	pass

func _on_button_4_pressed():
	$Area2D.visible = true
	$Button4.visible = false
	get_tree().paused = true

# When the pause button is clicked, pause all the process functions and the animations
# And show the paused menu

func _on_button_pressed():
	$Area2D.visible = false
	$Button4.visible = true
	get_tree().paused = false

# When continue button is clicked, hide itself again
	
func _on_button_3_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/LevelSelection.tscn")

# When exit button is clicked, go back to the level selection scene
