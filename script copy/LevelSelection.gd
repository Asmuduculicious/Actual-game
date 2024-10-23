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
	

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/Tutorial.tscn")

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


func _on_tutorial_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/MainPage.tscn")
