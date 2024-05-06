extends Node2D

@export var speed = 50
@export var rotation_speed = 2
@export var shoot_speed = 1700
@export var max_ammo = 3
@export var ammo = max_ammo
var health
const MAX_HEALTH = 10
var reload_time = 3.0
var remaining_reload_time = 0.0
var velocity = Vector2.ZERO
var reload_progress_bar
var blackHole
var blackHoleSuction = 1500000

var projectile_scene = preload("res://scenees/heatMissile.tscn")
var explosion_scene = preload("res://scenees/mediumExplosion.tscn")


func _ready():
	$Timer.set_wait_time(reload_time)
	$TextureProgressBar.visible = false
	
	
	health = MAX_HEALTH
	
	# Start a timer to replenish ammo after a certain duration


func _process(delta):
	print(health)
	# Check keyboard input for rotation
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
	
	# Rotate the sprite
	rotate(rotation_speed * rotation_direction * delta)
	
	# Calculate movement direction based on rotation
	var direction = Vector2(1, 0).rotated(rotation)
	
	# Check keyboard input for movement
	if Input.is_action_pressed("foreward"):
		velocity += direction * speed * delta
	elif Input.is_action_pressed("down"):
		velocity -= direction * speed/2 * delta
	
	# Apply friction to slow down the player's movement
	velocity *= 0.97
	
	# Move the sprite based on velocity
	position += velocity
	
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
		position += suction_direction * suction_strength * delta
	
	
		# Shooting logic
	if Input.is_action_just_pressed("shoot") and ammo > 0:
		shoot()
		ammo = ammo - 1
	
	if Input.is_action_just_pressed("reload") and ammo < max_ammo and $Timer.time_left <= 0:
		start_reload()
		
		# Update the reload progress bar if reloading
	if $Timer.time_left > 0:
		
		#3 / 3-2-1-0 
		$TextureProgressBar.value = (((reload_time - $Timer.time_left) / reload_time ) * 100)
		
		print($TextureProgressBar.value)
	
func shoot():
	# Calculate the spawn position of the projectile
	var spawn_position = position + Vector2(64, 0).rotated(rotation)
	
		# Instantiate the projectile scene
	var new_projectile = projectile_scene.instantiate()
	
		# Set the projectile's position and rotation
	new_projectile.position = spawn_position
	new_projectile.rotation = rotation
	
		# Set the projectile's velocity
	var shootDirection = Vector2(1, 0).rotated(rotation)
	new_projectile.set_velocity(shootDirection * shoot_speed)
	
		# Add the projectile to the scene
	get_parent().add_child(new_projectile)
	



func start_reload():
	if ammo < max_ammo and $Timer.time_left <= 0:
		# Start reloading
		remaining_reload_time = reload_time
		$Timer.start()

		# Show the reload progress bar
		$TextureProgressBar.visible = true

func _on_timer_timeout():
	# Stop reloading when timer times out
	remaining_reload_time = 0
	$Timer.set_wait_time(reload_time)
	$Timer.stop()

	# Hide the reload progress bar
	$TextureProgressBar.visible = false

	# Refill ammo
	ammo = max_ammo

func setVelocity(newVelocity):
	velocity = newVelocity



# Called when another area enters this area.
func _on_area_2d_area_entered(area):
	print("Collision detected with body:", area.name)
	if area.name == "Obstical":
		health -= 10
		death()
	elif area.name == "missile":
		health -=10
		death()
	if area.name == "smallExplosion":
		print("closeExplosion")
		health -= 10
		death()
	if area.name == "mediumExplosion":
		print("mediumExplosion")
		health -=5
		var direction = (global_position - area.global_position).normalized()
			# Apply a force to simulate the blast effect
		velocity = direction * 100
		death()
	if area.is_in_group("blackHole"):
		blackHole = area
	if area.name == "blackHoleCenter":
		print("entering the center...")
		health -= 100
		death()
	if area.name == "mediumExplosionArea":
		var distance_to_explosion = global_position.distance_to(area.global_position)
		var damage = calculate_damage(distance_to_explosion)
		print("Damage: ", damage)
		health -= damage
		var direction = (global_position - area.global_position).normalized()
		velocity = direction * 100  # Apply force to simulate blast effect
		death()
		
		
		
func death():
	if(health <= 0):
			
		# Implement player death logic here
		

		
		# 1. Play death animation (if applicable)
		#area.play_death_animation()  # Replace with your actual method to play the death animation
		get_tree().change_scene_to_file("res://scenees/GameOverScreen.tscn")
		
		# 3. Reset the level (if applicable)
		# get_tree().reload_current_scene()  # Uncomment this line if you want to reset the level



func _on_player_hit_box_area_exited(area):
	if area.is_in_group("blackHole"):
		blackHole = null
		
func calculate_damage(distance):
	# Define the radius of the explosion
	var explosion_radius = 490.0  # Adjust this according to your needs
	
	# Calculate the damage based on distance from explosion
	var max_damage = 10
	var min_damage = 1
	var damage_range = max_damage - min_damage
	var normalized_distance = clamp((explosion_radius - distance) / explosion_radius, 0.0, 10.0)
	var damage = int(min_damage + normalized_distance * damage_range)

	
	return damage
