extends Sprite2D

@export var speed = 50
@export var rotation_speed = 2
@export var shoot_speed = 1700
var health
const MAX_HEALTH = 10
var reload_time = 3.0
var remaining_reload_time = 0.0
var velocity = Vector2.ZERO
var reload_progress_bar
var blackHole
var blackHoleSuction = 1500000
var isExploding = false

var ammo_Type_list = ["Heat Missile", "Machine Gun","Nuke"]
var ammo_link = [preload("res://scenees/player and weapons/heatMissile.tscn"),preload("res://scenees/player and weapons/bullet.tscn"),preload("res://scenees/player and weapons/nuke.tscn")]
var max_amount_per_ammo = [3,40,1]

var machine_gun_wait_time = .1
var can_shoot = true


var _stateMachine

var current_ammo_index = 0
var projectile_scene = ammo_link[current_ammo_index]
var current_ammo = ammo_Type_list[current_ammo_index]
var max_ammo = max_amount_per_ammo[current_ammo_index]
var ammo = max_ammo


func _ready():
	$Timer.set_wait_time(reload_time)
	$TextureProgressBar.visible = false
	_stateMachine = $AnimationTree.get("parameters/playback")
	
	
	health = MAX_HEALTH
	
	# Start a timer to replenish ammo after a certain duration


func _process(delta):
	# Check keyboard input for rotation
	var rotation_direction = 0
	
	
	
	
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
	
	# Rotate the sprite
	if rotation_speed != null and rotation_direction != null and delta != null:
		rotate(rotation_speed * rotation_direction * delta)
	else:
	# Handle the case where one of the variables is nil
		pass
	
	# Calculate movement direction based on rotation
	var direction = Vector2(0, -1).rotated(rotation)
	
	# Check keyboard input for movement
	if Input.is_action_pressed("foreward"):
		velocity += direction * speed * delta
		_stateMachine.travel("flying")
	elif Input.is_action_pressed("down"):
		velocity -= direction * speed/2 * delta
		_stateMachine.travel("engineOff")
	else:
		_stateMachine.travel("engineOff")
		
	if isExploding:
		_stateMachine.travel("explosion")
		velocity = Vector2.ZERO 
	
		
	
	
	# Apply friction to slow down the player's movement
	velocity *= 0.97
	
	# Move the sprite based on velocity
	position += velocity
	
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var collisionShape = blackHole.get_node("CollisionShape2D") # Assuming the collision shape node is named "wideBlackHoleArea"
		var radius = collisionShape.shape.radius
		var suction_strength = blackHoleSuction / (distance_to_black_hole - radius/ radius)
		position += suction_direction * suction_strength * delta
	
	
		# Shooting logic
	if Input.is_action_pressed("shoot") and ammo > 0 and current_ammo == "Machine Gun":
		if can_shoot:
			shoot()
			ammo = ammo - 1
			can_shoot = false
			$machine_gun_timer.start()
		
	if Input.is_action_just_pressed("shoot") and ammo > 0:
		shoot()
		ammo = ammo - 1
		

	
	if Input.is_action_just_pressed("reload") and ammo < max_ammo and $Timer.time_left <= 0:
		start_reload()
		
		
	if Input.is_action_just_pressed("switchAmmo") and ammo == max_ammo:
		switchAmmo()
		
		# Update the reload progress bar if reloading
	if $Timer.time_left > 0:
		
		#3 / 3-2-1-0 
		$TextureProgressBar.value = (((reload_time - $Timer.time_left) / reload_time ) * 100)
		
	
func shoot():
	var random_variance = 0
	# Calculate the spawn position of the projectile
	if current_ammo == "Machine Gun":
		random_variance =randf_range(-10,10)
	var spawn_position = position + Vector2(random_variance, -64).rotated(rotation)
	
		# Instantiate the projectile scene
	var new_projectile = projectile_scene.instantiate()
	
		# Set the projectile's position and rotation
	new_projectile.position = spawn_position
	new_projectile.rotation = rotation
	
		# Set the projectile's velocity
	var shootDirection = Vector2(0, -1).rotated(rotation)
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
	if area.name == "Obstical":
		health -= 10
		death()
		
	elif area.name == "pearcing_missile":
		health -=10
		death()
		
	elif area.name == "missile":
		health -= 3
		death()
		
	elif area.name == "nuclear_missile_area":
		health -= 1
		death()
		
	if area.name == "bullet_area":
		health -= 1
		death()
		
		
	if area.is_in_group("blackHole"):
		blackHole = area
		
	if area.name == "blackHoleCenter":
		health -= 100
		death()
		
	if area.name == "mediumExplosionArea":
		var distance_to_explosion = global_position.distance_to(area.global_position)
		var damage = calculate_damage(distance_to_explosion)
		health -= damage
		var direction = (global_position - area.global_position).normalized()
		var explosion_strength = 5000 / distance_to_explosion
		velocity = direction *  explosion_strength # Apply force to simulate blast effect
		death()
		
		
		
func death():
	if(health <= 0):
			
		# Implement player death logic here
		isExploding = true
		$death_timer.start()


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



func _on_death_delay_timeout():
			
		# 2. Display game over screen (if applicable)
	get_tree().change_scene_to_file("res://scenees/GameOverScreen.tscn")
	

func switchAmmo():
	if current_ammo_index + 1 >= ammo_Type_list.size():
		current_ammo_index = 0  # Corrected from '==' to '=' for assignment
	else:
		current_ammo_index += 1
		
	projectile_scene = ammo_link[current_ammo_index]
	current_ammo = ammo_Type_list[current_ammo_index]
	max_ammo = max_amount_per_ammo[current_ammo_index]
	ammo = max_ammo
	


func _on_machine_gun_timer_timeout():
	can_shoot = true
