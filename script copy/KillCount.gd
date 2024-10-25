extends CanvasLayer

@onready var global = get_node("/root/global")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label.text = ("Kill count : " + str(global.kills)) + "\n"  + ("HP : " + str(global.hp))

# Have a label on the screen that updates on time to the HP of the player
# As well as the amount of enemies you have killed in total
