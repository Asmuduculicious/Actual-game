extends Node2D

@onready var global = get_node("/root/global")

# Called when the node enters the scene tree for the first time.
func _ready():
	global.current_level = "Level_4"
	
# Setting the current level as a global variable, so that in the death scene it will respawn you in this scene
