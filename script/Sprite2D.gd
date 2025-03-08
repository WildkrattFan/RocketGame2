extends Sprite2D

@export var speed = 50
@export var rotation_speed = 2
@export var shoot_speed = 1500
@export var arrowText : Texture2D
@export var red_arrowText : Texture2D
var health
const MAX_HEALTH = 10
var reload_time = 5.0
var remaining_reload_time = 0.0
var velocity = Vector2.ZERO
var normal_max_velocity = 15
var max_velocity = 15
var reload_progress_bar
var blackHole
var blackHoleSuction = 1500000
var isExploding = false

var team = "red"

var ammo_Type_list = ["Heat Missile", "Machine Gun","Nuke"]
var ammo_link = [preload("res://scenees/player and weapons/heatMissile.tscn"),preload("res://scenees/player and weapons/bullet.tscn"),preload("res://scenees/player and weapons/nuke.tscn")]
var max_amount_per_ammo = [3,40,1,1]

var machine_gun_wait_time = .1
var can_shoot = true

var _stateMachine

var current_ammo_index = 0
var projectile_scene = ammo_link[current_ammo_index]
var current_ammo = ammo_Type_list[current_ammo_index]
var max_ammo = max_amount_per_ammo[current_ammo_index]
var ammo = max_ammo

var score = 0

var enemyScannedList = []
var enemyPosList = []
var directionList = []

var direction = Vector2.ZERO

@export var abilityCards = []
var abilityInstances = []
var spriteChildren = []

var invincible = false

signal exploded
signal points_added




func _ready():

	$CanvasLayer/score.text = "Points: " + str(score)
	$Timer.set_wait_time(reload_time)
	_stateMachine = $AnimationTree.get("parameters/playback")
	$CanvasLayer/ammoTypeLabel.text = "Ammo: " + current_ammo
	$CanvasLayer/TextureProgressBar.value = (float(ammo) / float(max_ammo)) * 100
	$CanvasLayer/ammoRemainingLabel.text = str(ammo) + "/" + str(max_ammo)
	health = MAX_HEALTH
	$CanvasLayer/healthBar.value = (float(health) / float(MAX_HEALTH)) * 100
	

	var abilityPosition = 400
	for ability in abilityCards:
		var abilitySprite = Sprite2D.new()
		var abilityInstance = ability.instantiate()
		add_child(abilityInstance)
		abilitySprite.texture = abilityInstance.get_child(0).texture
		abilitySprite.scale = Vector2(.05,.05)
		abilitySprite.position = Vector2(abilityPosition,20)
		$CanvasLayer/abilities.add_child(abilitySprite)
		abilityInstances.append(abilityInstance)
		spriteChildren.append(abilitySprite)
		abilityPosition += 35

	
	# Start a timer to replenish ammo after a certain duration

func _process(delta):
	if is_multiplayer_authority() or true:
		handle_input(delta)
	apply_movement(delta)
	scan()


func handle_input(delta):
	# Check keyboard input for rotation
	var rotation_direction = 0
	if Input.is_action_pressed("right"):
		rotation_direction += 1
	if Input.is_action_pressed("left"):
		rotation_direction -= 1

	# Rotate the sprite
	rotate(rotation_speed * rotation_direction * delta)

	# Calculate movement direction based on rotation
	direction = Vector2(0, -1).rotated(rotation)


	# Check keyboard input for movement
	if Input.is_action_pressed("foreward"):
		velocity += direction * speed * delta
		_stateMachine.travel("flying")
		$trail.emitting = true

	elif Input.is_action_pressed("down"):
		velocity -= direction * speed / 2 * delta
		_stateMachine.travel("engineOff")
		$trail.emitting = false
	else:
		_stateMachine.travel("engineOff")
		$trail.emitting = false

	if isExploding:
		_stateMachine.travel("explosion")
		velocity = Vector2.ZERO

	# Apply friction to slow down the player's movement
	velocity *= 0.97
	
	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity
	
	if Input.is_action_just_pressed("ability"):

		var ability = abilityInstances.pop_front()
		if ability:
			ability.use(delta, self)
			$CanvasLayer/abilities.offset = Vector2($CanvasLayer/abilities.offset.x - 35, $CanvasLayer/abilities.offset.y)
			$CanvasLayer/abilities.remove_child(spriteChildren.pop_front())


	# Shooting logic
	if Input.is_action_pressed("shoot") and ammo > 0 and current_ammo == "Machine Gun" and $Timer.time_left <= 0 and !isExploding:
		if can_shoot:
			shoot()
			ammo -= 1
			update_ammo_display()
			can_shoot = false
			$machine_gun_timer.start()

	
	if Input.is_action_just_pressed("shoot") and ammo > 0 and $Timer.time_left <= 0 and !isExploding:
		shoot()
		ammo -= 1
		update_ammo_display()


	if ammo <= 0:
		$CanvasLayer/ammoRemainingLabel.add_theme_color_override("default_color", Color(224, 27, 0))
	else:
		$CanvasLayer/ammoRemainingLabel.add_theme_color_override("default_color", Color(0, 154, 39))

	if Input.is_action_just_pressed("reload") and ammo < max_ammo and $Timer.time_left <= 0 and !isExploding:
		start_reload()

	if Input.is_action_just_pressed("switchAmmo") and ammo == max_ammo and !isExploding:
		switchAmmo()
		update_ammo_display()

	# Update the reload progress bar if reloading
	if $Timer.time_left > 0:
		$CanvasLayer/TextureProgressBar.value = ((reload_time - $Timer.time_left) / reload_time) * 100

func apply_movement(delta):
	position += velocity

	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var collisionShape = blackHole.get_node("CollisionShape2D") # Assuming the collision shape node is named "wideBlackHoleArea"
		var radius = collisionShape.shape.radius
		var suction_strength = blackHoleSuction / (distance_to_black_hole - radius / radius)
		position += suction_direction * suction_strength * delta


func shoot():
	var random_variance = 0
	# Calculate the spawn position of the projectile
	if current_ammo == "Machine Gun":
		random_variance = randf_range(-10, 10)
	var spawn_position = position + Vector2(random_variance, -85).rotated(rotation)

	
	# Instantiate the projectile scene
	var new_projectile = projectile_scene.instantiate()
	
	# Set the projectile's position and rotation
	new_projectile.position = spawn_position
	new_projectile.rotation = rotation
	
	# Set the projectile's velocity
	var shootDirection = Vector2(0, -1).rotated(rotation)
	new_projectile.set_velocity(shootDirection * shoot_speed + self.velocity)
	
	# Add the projectile to the scene
	new_projectile.setPlayer(self)
	get_parent().add_child(new_projectile)


func start_reload():
	if ammo < max_ammo and $Timer.time_left <= 0:
		# Start reloading
		remaining_reload_time = reload_time
		$Timer.start()
		$CanvasLayer/ammoTypeLabel.text = "Reloading..."


		# Show the reload progress bar
		$CanvasLayer/ammoRemainingLabel.text = str(0) + "/" + str(max_ammo)

func _on_timer_timeout():
	# Stop reloading when timer times out
	remaining_reload_time = 0
	$Timer.set_wait_time(reload_time)
	$Timer.stop()
	$CanvasLayer/ammoTypeLabel.text = "Ammo: " + current_ammo

	# Refill ammo
	ammo = max_ammo
	$CanvasLayer/ammoRemainingLabel.text = str(ammo) + "/" + str(max_ammo)


func setVelocity(newVelocity):
	velocity = newVelocity


func calculate_damage(distance):
	var explosion_radius = 490.0
	var max_damage = 10
	var min_damage = 1
	var damage_range = max_damage - min_damage
	var normalized_distance = clamp((explosion_radius - distance) / explosion_radius, 0.0, 10.0)
	var damage = int(min_damage + normalized_distance * damage_range)

	return damage

# Called when another area enters this area.
func _on_area_2d_area_entered(area):

	if area.name == "Obstical":
		health -= 10
		death()
	if area.is_in_group("Obstical"):
		health -= 10
		death()
		
	elif area.name == "pearcing_missile":
		health -=10
		death()
		
	elif area.name == "missile" and !invincible:
		health -= 3
		death()
		
	elif area.name == "nuclear_missile_area" and !invincible:
		health -= 1
		death()
		
	if area.name == "bullet_area" and !invincible:
		health -= 1
		death()
		
		
	if area.is_in_group("blackHole"):
		blackHole = area

		
	if area.name == "blackHoleCenter":
		health -= 100
		death()
	if area.name == "hitBox":
		health -= 100
		death()
		
	if area.name == "mediumExplosionArea" and !invincible:
		var distance_to_explosion = global_position.distance_to(area.global_position)
		var damage = calculate_damage(distance_to_explosion)
		health -= damage
		var direction = (global_position - area.global_position).normalized()
		var explosion_strength = 5000 / distance_to_explosion
		velocity = direction *  explosion_strength # Apply force to simulate blast effect

		death()

func death():
	$CanvasLayer/healthBar.value = (float(health) / float(MAX_HEALTH)) * 100

	if(health <= 0):
		# Implement player death logic here
		isExploding = true
		$death_timer.start()

func _on_player_hit_box_area_exited(area):
	if area.is_in_group("blackHole"):
		blackHole = null


func _on_death_delay_timeout():
	# 2. Display game over screen (if applicable)
	$CanvasLayer/abilities.visible = false
	exploded.emit()


func switchAmmo():
	if current_ammo_index + 1 >= ammo_Type_list.size():
		current_ammo_index = 0  # Corrected from '==' to '=' for assignment
	else:
		current_ammo_index += 1
		
	projectile_scene = ammo_link[current_ammo_index]
	current_ammo = ammo_Type_list[current_ammo_index]
	max_ammo = max_amount_per_ammo[current_ammo_index]
	ammo = max_ammo
	$CanvasLayer/ammoTypeLabel.text = "Ammo: " + current_ammo


func _on_machine_gun_timer_timeout():
	can_shoot = true


func add_score(num):
	score += num
	$CanvasLayer/score.text = "Points: " + str(score)
	points_added.emit()


func set_team(New_team):
	team = New_team

	
func _enter_tree():
	set_multiplayer_authority(name.to_int())


func update_ammo_display():
	$CanvasLayer/TextureProgressBar.value = (float(ammo) / float(max_ammo)) * 100
	$CanvasLayer/ammoRemainingLabel.text = str(ammo) + "/" + str(max_ammo)
	
	
func get_points():
	return score
	
func scan():
	var closest_enemy: Node2D = null
	var shortest_distance: float = INF  # Start with a very large number
	var enemy_scanned_list = get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemy_scanned_list:
		if enemy.position != Vector2.ZERO:
			var distance = (enemy.position - global_position).length()  # Calculate the distance

		# Update closest_enemy if this enemy is closer
			if distance < shortest_distance:
				shortest_distance = distance
				closest_enemy = enemy
	 # Update arrow if a closest enemy is found
	if closest_enemy != null:
		var closest_enemy_position = closest_enemy.global_position
		var direction_to_enemy = (closest_enemy_position - global_position).normalized()  # Direction vector
		
		# Calculate rotation in radians
		var angle_to_enemy = direction_to_enemy.angle()
 # Adjust as needed
		angle_to_enemy += PI/2
		# Rotate the arrow to face the direction of the enemy
		$CanvasLayer/Arrow.rotation = angle_to_enemy
		
	else:
		# Hide the arrow if no enemies are found
		$CanvasLayer/Arrow.visible = false


func _on_super_close_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		$CanvasLayer/Arrow.texture = red_arrowText
	


func _on_super_close_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		$CanvasLayer/Arrow.texture = arrowText
