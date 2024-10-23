extends Area2D

var speed = 150
var direction = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x((speed * direction) * delta)

func _ready():
	$Arrow.texture = preload("res://assets/Others/Bullet.png")

func _on_area_entered(area):
	if area.has_meta("enemy") or area.has_meta("player") or area.has_meta("wall"):
		print(area)
		queue_free()
