extends CharacterBody2D

var speed = 0
var direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var stance = ["patrolling", "alarmed", "fighting"]
var current_stance = ""
var aware = 0
var in_range = false
var flipped = false
var type = ""
var enemy_types = ["melee", "ranged"]
var attack_range = false
var random_enemy_type = 0
var random_enemy_direction = 0
@export var bullet_scene: PackedScene
var shot = false
@onready var global = get_node("/root/global")

# Setting variables for later use, also allow access to the global variables


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

# As there will be multiple triggers for enemy flipping, I have made it into a function
# When they flip, the collisionshape for their attacks, their sprite, and area all flip
# Default scale.x is 1, so by testing if it is higher than 0.5 instead of checking for equal to 1 as that has caused issue before

func _shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $Area2D/Gun.global_position
	bullet.direction = $AnimatedSprite2D.scale.x
	# bullet.position.y += 200
	add_sibling(bullet)

# Spawning a bullet scene at the position of the designated point
# And setting the bullet direction to the same way the sprite is facing
# Then adds it as a sibling

func _ready():
	current_stance = stance[0]
	random_enemy_type = randi_range(0,1)
	type = enemy_types[random_enemy_type]
	if type == enemy_types[0]:							
		$Area2D/Front.target_position.y = 25
	elif type == enemy_types[1]:
		$Area2D/Front.target_position.y = 75
	if type == enemy_types[0]:
		$AnimatedSprite2D.play("DaggerIdle")
	if type == enemy_types[1]:
		$AnimatedSprite2D.play("GunIdle")
	random_enemy_direction = randi_range(0,1)
	if random_enemy_direction < 1:
		_flip()
	
# These will trigger whenever they are spawned as the level is readied
# Their stance is set to 0(patroling), using randi() so that they either spawn as ranged enemy or melee enemy
# Then setting the size of their raycast 2d, as these are different for different type of enemy
# Then using randi() again to make their spawning direction random

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
	# This part is when their front collision shape is detecting something
	# Based on what they are colliding with
	# If it has the metadata "wall" which tiles in the tilemap do, they turn around
	# If it has the metadata "enemy" which are on enemies, they also turns around
	# They are also no longerin the fighting state if they were in it before
	# If they detect the player, and they are in any state other than fighting, their state changes to fighting
	# And they begin attacking as player is in their attack range 

	if current_stance == stance[2] and attack_range == true:
		if type == enemy_types[0]:
			$AnimatedSprite2D.play("DaggerAttack")
			$AnimationPlayer.play("Dagger_Attack")
			
	
	# If they are melee enemies, when the player is in their attack range, they will attack
	
		elif type == enemy_types[1]:
			if shot == false:
				shot = true
				$AnimatedSprite2D.play("GunAttack")
				_shoot()
				$ShootingTimer.start()
	# If they are ranged enemies, they will shoot if they are in the fighting state constantly

	if $Area2D/Ground.is_colliding():
		if flipped == false:
			velocity.x = direction * speed
	else:
		if current_stance != stance[2]:
			_flip()

	# If they can detect a platform under them, they keep moving at a constant speed
	# If they can not, then they flip unless they are fighting, at which they continue moving
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# If they are not on the floor, they fall

	if current_stance == stance[0]:
		speed = 30


	if current_stance == stance[1]:
		speed = 0
	

	if current_stance == stance[2]:
		speed = 60
	
	# Setting speed for different speeds of them

func _on_entering_detection(area):
	if current_stance == stance[0]:
		if area.has_meta("player"):
			in_range = true
			current_stance = stance[1]
			aware += 1
			$DetectionTimer.start()
	
# When player enters the detection area, they enters the alarmed state
# This starts the timer for detection

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
			

# Every time the detection timer runs out, if the player is still in the area, they get more awareness
# If awareness is high enough, they enter the combat stance
# If the player is not in the area, they lose awareness
# If awareness is low enough, they keep patroling

func _on_leaving_detection(area):
	if area.has_meta("player"):
		in_range = false
		$ExitTimer.start()

# When something leaves the detection area, checks if that thing is player
# So that when the player is no longer in the dtection area, the arlm variable doesn't increase

func _on_flip_timer_timeout():
	flipped = false

# Adding a timer to the flip function, so that they don't spin infinitely when between a wall and an enemy

func _on_shooting_timer_timeout():
	shot = false
	
# A timer for the shooting cooldown

func _on_exit_timer_timeout():
	if in_range == false:
		aware -= 1
		if aware == 0:
			current_stance = stance[0]
		else:
			$ExitTimer.start()
	
# After the player leaves the detection area, the awareness goes down, and if it drops below 0
# They reverts back to patrolling state
# If it doesn't yet go to 0, starts the timer again

func _on_area_area_entered(area):
	if area.has_meta("player_weapon"):
		global.kills += 1
		queue_free()

# When it is hit by an area with the metadata player weapon, it adds 1 to the kill count
# And then it deletes itself with queue_free()
