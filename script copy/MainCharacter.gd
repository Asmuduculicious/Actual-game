extends CharacterBody2D

@export var speed := 100.0
@export var jump_velocity = -200.0

# Exporting the speed and jump velocity, so that it is easier to adjust later on

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Using default gravity option in the settings

@export var attacking = false

# Exporting the attacking as a variable so that it can be changed in AnimationPlayer

var fall_attacking = false
var double_jump = true
var jump_start = false
var attacked = false
var started = false
var walking = false
var locked = false
@onready var global = get_node("/root/global")

# Creating local and global variables for later usage

func _ready():
	$Node2D2/AnimatedSprite2D.play("Idle")
	global.hp = 100

# Setting the starting health points of the player and how they are spawned

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5
		if jump_start == false:
			if fall_attacking == true:
				if velocity.y < 150:
					$Node2D2/AnimatedSprite2D.play("JumpAttackStart")
					$AnimationPlayer.play("Holding")
				else:
					$Node2D2/AnimatedSprite2D.play("JumpAttackEnd")
					$AnimationPlayer.play("Fall_Attacking")
					$Timer4.start()
			else:
				if velocity.y < 150:
					$Node2D2/AnimatedSprite2D.play("JumpAirborne")
				else:
					$Node2D2/AnimatedSprite2D.play("JumpFall")
		else:
			$Node2D2/AnimatedSprite2D.play("JumpStart")
	else:
		double_jump = true
		if not jump_start and abs(velocity.x) > 0 and not fall_attacking and not attacking:
			$Node2D2/AnimatedSprite2D.play("Walk")
		elif $Node2D2/AnimatedSprite2D.animation == "Walk":
			$Node2D2/AnimatedSprite2D.stop()
			
	# If the character is not on the ground, they will be falling at the set speed
	# Then, depending on if they are just starting the jump
	# If they are, play the JumpStart animation
	# If they are not, depending on if they are trying to attack or not, play either 
	# Either the falling animation, or the landing animation when they are close to the ground
	# If they are on the groond, it plays the walking animation and allow them to double jump

	if not attacking:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			if started == false:
				started = true
				jump_start = true
				$Node2D2/AnimatedSprite2D.play("JumpStart")
				$Timer.start()
				$Timer3.start()
		elif Input.is_action_just_pressed("ui_accept") and double_jump:
			velocity.y = jump_velocity
			double_jump = false
			$Node2D2/AnimatedSprite2D.play("JumpStart")
			
	# Checks if the player is attacking
	# Deny jump if they are attacking
	# If they are on the floor, and they aren't already jumping, do the jump
	# If they are not on the floor, check for double jump so that no infinite jumping
			
		var direction = Input.get_axis("ui_left", "ui_right")
		if attacked == false:
			if locked == false:
				if direction:
					velocity.x = direction * speed
					$Node2D2.scale.x = direction
				else:
					velocity.x = move_toward(velocity.x, 0, speed)
	# Checks user input for A and W, which are ui_left and ui_right
	# Then if they are not attacking and not being knocked back, they can move
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	
	if Input.is_action_just_pressed("ui_attack"):
		if is_on_floor() and fall_attacking == false:
			if attacked == false:
				if attacking == false:
					attacked = true
					$Node2D2/AnimatedSprite2D.play("AttackStart")
					$AnimationPlayer.play("Attacking")
					$Node2D2/AnimatedSprite2D.play("Attacking")
					$Timer2.start()
			else:
				if attacked == false:
					$AnimationPlayer.play("RepeatAttack")
					$Node2D2/AnimatedSprite2D.play("Attacking")
					attacked = false
		else:
			fall_attacking = true
	# When they press the attack key(Space)
	# If they are on the floor, set their status to attacking, and do the attack
	# If they are already attacking then don't redo it
	# If they are in the air, check if they are already attacking
	# Then run the drop attack animation for the animation player
			
	move_and_slide()

func _on_timer_timeout():
	jump_start = false

func _on_timer_2_timeout():
	attacked = false
	$Node2D2/AnimatedSprite2D.play("AttackEnd")

func _on_timer_3_timeout():
	velocity.y = jump_velocity
	started = false

func _on_timer_4_timeout():
	fall_attacking = false

func _on_area_2d_2_area_entered(area):
	if area.has_meta("enemy_weapon"):
		_damaged(25)
		if global.hp <= 0:
			get_tree().change_scene_to_file("res://scene/Dead.tscn")
		else:
			locked = true
			if area.has_meta("dagger"):
				velocity.x = 200 * area.scale.x
				velocity.y = -300
				$Timer5.start()
			elif area.has_meta("bullet"):
				velocity.x = 200 * area.direction
				velocity.y = -300
				$Timer5.start()
	if area.has_meta("Exit"):
		get_tree().change_scene_to_file("res://scene/LevelSelection.tscn")
		if global.current_level == "Tutorial":
			global.tutorial = true
		if global.current_level == "Level_1":
			global.level_1 = true
		if global.current_level == "Level_2":
			global.level_2 = true
		if global.current_level == "Level_3":
			global.level_3 = true
		if global.current_level == "Level_4":
			global.level_4 = true
		if global.current_level == "Level_5":
			global.level_5 = true
	if area.has_meta("Spike"):
		_damaged(50)
		if global.hp <= 0:
			get_tree().change_scene_to_file("res://scene/Dead.tscn")
		else:
			if area.in_pit:
				velocity.y = area.spikiness
		
	# This part is when enters another area
	# Takes imput and checks for metadata
	# Which allows me to modify the outcome based on the type of metadata the area has
	# If its enemy weapon or spike, take damage
	# If it's exit, goes back to level selection scene

func _on_timer_5_timeout():
	locked = false

# After the timer runs out, they are no longer knocked back and can move freely
	
func _damaged(damage_amount):
	global.hp -= damage_amount

# A function that can be used to take a parameter and do different things with it
