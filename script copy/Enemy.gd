extends CharacterBody2D

var speed = 0
@export var direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var stance = ["patrolling", "alarmed", "fighting"]
var current_stance = ""
var aware = 0
var in_range = false
var flipped = false
var type = ""
var enemy_types = ["melee", "ranged"]
var attack_range = false
var a = 0
var b = 0
@export var bullet_scene: PackedScene
var shot = false
@onready var global = get_node("/root/global")

func _flip():
	direction = direction * -1
	if $AnimatedSprite2D.scale.x > 0.5:
		$AnimatedSprite2D.scale.x = -1
	else:
		$AnimatedSprite2D.scale.x = 1

	if $Detection/Character.scale.x > 0.5:
		$Detection/Character.scale.x = -1
		$Detection/Character.position.x = $Detection/Character.position.x * -1
	else:
		$Detection/Character.scale.x = 1
		$Detection/Character.position.x = $Detection/Character.position.x * -1

	if $Area2D.scale.x > 0.5:
		$Area2D.scale.x = -1
	else:
		$Area2D.scale.x = 1
		$Area2D.position.x = $Area2D.position.x * -1
	
	if $Area2D2.scale.x > 0.5:
		$Area2D2.scale.x = -1
	else:
		$Area2D2.scale.x = 1
		$Area2D2.position.x = $Area2D2.position.x * -1

func _shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $Area2D/Gun.global_position
	bullet.direction = $AnimatedSprite2D.scale.x
	# bullet.position.y += 200
	add_sibling(bullet)

func _ready():
	current_stance = stance[0]
	a = randi_range(0,1)
	type = enemy_types[a]
	if type == enemy_types[0]:							
		$Area2D/Front.target_position.y = 25
	elif type == enemy_types[1]:
		$Area2D/Front.target_position.y = 75
	if type == enemy_types[0]:
		$AnimatedSprite2D.play("DaggerIdle")
	if type == enemy_types[1]:
		$AnimatedSprite2D.play("GunIdle")
	b = randi_range(0,1)
	if b < 1:
		_flip()
	

func _physics_process(delta):
	move_and_slide()
	if $Area2D/Front.is_colliding():
		if not $Area2D/Front.get_collider() == null and $Area2D/Front.get_collider().has_meta("wall"):
			if current_stance == stance[0]:
				if flipped == false:
					flipped = true
					$FlipTimer.start()
					_flip()
			elif current_stance == stance[2]:
				pass
				if not $Area2D/Front.get_collider().has_meta("player"):
					if flipped == false:
						flipped = true
						$FlipTimer.start()
						_flip()
						current_stance = stance[0]
						
		if not $Area2D/Front.get_collider() == null and $Area2D/Front.get_collider().has_meta("enemy"):
			if current_stance == stance[0]:
				if flipped == false:
					flipped = true
					$FlipTimer.start()
					_flip()
			elif current_stance == stance[1]:
				pass
			elif current_stance == stance[2]:
				if flipped == false:
					flipped = true
					$FlipTimer.start()
					_flip()
				
		if not $Area2D/Front.get_collider() == null and $Area2D/Front.get_collider().has_meta("player"):
			attack_range = true
			if current_stance != stance[2]:
				aware = 5
				current_stance = stance[2]
		else:
			attack_range = false

	if current_stance == stance[2] and attack_range == true:
		if type == enemy_types[0]:
			$AnimatedSprite2D.play("DaggerAttack")
			$AnimationPlayer.play("Dagger_Attack")
			
		elif type == enemy_types[1]:
			if shot == false:
				shot = true
				$AnimatedSprite2D.play("GunAttack")
				_shoot()
				$ShootingTimer.start()

	if $Area2D/Ground.is_colliding():
		if flipped == false:
			velocity.x = direction * speed
	else:
		if current_stance != stance[2]:
			_flip()

	if not is_on_floor():
		velocity.y += gravity * delta

	if current_stance == stance[0]:
		speed = 20

	if current_stance == stance[1]:
		speed = 0

	if current_stance == stance[2]:
		speed = 50

func _on_entering_detection(area):
	if current_stance == stance[0]:
		if area.get_parent().has_meta("player"):
			in_range = true
			current_stance = stance[1]
			aware += 1
			$DetectionTimer.start()

func _on_timer_timeout():
	if in_range == true:
		aware += 1
		if aware > 4:
			current_stance = stance[2]
			aware = 5
		else:
			$DetectionTimer.start()

	if in_range == false:
		aware -= 1
		if aware == 0:
			current_stance = stance[0]
		else:
			$DetectionTimer.start()

func _on_leaving_detection(area):
	if area.get_parent().has_meta("player"):
		in_range = false
		$ExitTimer.start()

func _on_flip_timer_timeout():
	flipped = false

func _on_shooting_timer_timeout():
	shot = false

func _on_exit_timer_timeout():
	if in_range == false:
		aware -= 1
		if aware == 0:
			current_stance = stance[0]
		else:
			$ExitTimer.start()

func _on_area_area_entered(area):
	if area.has_meta("player_weapon"):
		global.kills += 1
		queue_free()
