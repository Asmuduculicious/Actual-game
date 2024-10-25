extends Node2D
@onready var global = get_node("/root/global")

func _ready():
	$Label2.visible = false
	$Level1Button2.visible = false
	$Level2Button2.visible = false
	$Level3Button2.visible = false
	$Level4Button2.visible = false
	$Level5Button2.visible = false
	if global.tutorial == true:
		$Level1Button.disabled = true
		$Level1Button.visible = false
		$Level1Button2.disabled = false
		$Level1Button2.visible = true
	if global.level_1 == true:
		$Level2Button.disabled = true
		$Level2Button.visible = false
		$Level2Button2.disabled = false
		$Level2Button2.visible = true
	if global.level_2 == true:
		$Level3Button.disabled = true
		$Level3Button.visible = false
		$Level3Button2.disabled = false
		$Level3Button2.visible = true
	if global.level_3 == true:
		$Level4Button.disabled = true
		$Level4Button.visible = false
		$Level4Button2.disabled = false
		$Level4Button2.visible = true
	if global.level_4 == true:
		$Level5Button.disabled = true
		$Level5Button.visible = false
		$Level5Button2.disabled = false
		$Level5Button2.visible = true
		
# There are a bunch of buttons on this scene, and to show the user which ones they can click
# I have used different colored ones for these that they can click
# On the position of different buttons, there are two, and on ready, they by default shows the dark one
# To show that there is no access
# However, if the global variable shows that they have completed the previous level
# Then the next time this scene is loaded, it will show the next level as a light one
# To show that it is unlocked
# The button that aren't showing are disabled and not visible, the buttons that are showing are not disabled and visible
	

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/Tutorial.tscn")
	
# This button will always be active since they start with the tutorial

func _on_timer_timeout():
	$Label2.visible = false

func _on_level_1_button_pressed():
	$Label2.visible = true
	$Timer.start()

func _on_level_2_button_pressed():
	$Label2.visible = true
	$Timer.start()

func _on_level_3_button_pressed():
	$Label2.visible = true
	$Timer.start()

func _on_level_4_button_pressed():
	$Label2.visible = true
	$Timer.start()

func _on_level_5_button_pressed():
	$Label2.visible = true
	$Timer.start()
	
# The label is shown when they press a dark button
# To show say they don't have access
# And there is a label with the explaination
# The label goes away after a few seconds

func _on_level_1_button_2_pressed():
	get_tree().change_scene_to_file("res://scene/Level1.tscn")

func _on_level_2_button_2_pressed():
	get_tree().change_scene_to_file("res://scene/Level2.tscn")

func _on_level_3_button_2_pressed():
	get_tree().change_scene_to_file("res://scene/Level3.tscn")

func _on_level_4_button_2_pressed():
	get_tree().change_scene_to_file("res://scene/Level4.tscn")

func _on_level_5_button_2_pressed():
	get_tree().change_scene_to_file("res://scene/Level5.tscn")

# When they clock on button that they do have access to, they get moved to that scene


func _on_tutorial_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/MainPage.tscn")

# Exiting to the main page
