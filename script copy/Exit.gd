extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@export var speed = 20
var forwards = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if path_follow.progress_ratio == 1:
		if forwards == true:
			forwards = false
	if path_follow.progress_ratio == 0:
		if forwards == false:
			forwards = true
	if forwards == true:
		path_follow.progress += speed * delta
	else:
		path_follow.progress -= speed * delta
		
		
	
