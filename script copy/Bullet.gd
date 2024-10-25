extends Area2D

var speed = 150
var direction = ""

# Setting variables to be used later

func _process(delta):
	move_local_x((speed * direction) * delta)

# Constantly moving for the bullet

func _ready():
	$Arrow.texture = preload("res://assets/Others/Bullet.png")

# Make the bullet use the bullet sprite

func _on_area_entered(area):
	if area.has_meta("enemy") or area.has_meta("player") or area.has_meta("wall"):
		queue_free()

# Disappears after hitting either wall, enemy, or player so that it wouldn't hit the player twice
