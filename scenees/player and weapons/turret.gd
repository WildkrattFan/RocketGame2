extends Node2D

# Declare turret parameters
@export var rotation_speed: float = 100.0  # Rotation speed in radians per second
@export var missile_spawn_offset: Vector2 = Vector2(0, -200)  # Offset for missile spawn point
@export var reloadWaitTime = 3.0
var shoot_speed = 200
var health = 10

# Declare player reference and missile spawn point
var player = null
var player_velocity: Vector2 = Vector2.ZERO
var ammo = 1
var explosion = preload("res://scenees/mediumExplosion.tscn")

var _stateMachine
var playerInRange = false
var killedBy

# Called when the node enters the scene tree for the first time.
func _ready():
	_stateMachine = $AnimationTree.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerInRange:
		fire_heat_seeking_missile()
	if player != null:
		# Predict the player's position based on velocity
		if player_velocity != Vector2.ZERO:
			player_velocity = player.velocity
		var predicted_position = player.global_position + player.velocity * (missile_spawn_offset.length() / shoot_speed)
		# Calculate the direction to the predicted position
		var direction = (predicted_position - global_position).normalized()
		
		# Calculate the target angle
		var goal_rotation = direction.angle() - Vector2(0, -1).angle()
		
		rotation = lerp_angle(rotation, goal_rotation, rotation_speed * delta)

func _on_turret_scan_radius_area_entered(area):
	if area.name == "playerHitBox":
		player = area.get_parent()  # Assuming playerHitBox is a child of the player
		if player and "velocity" in player:
			player_velocity = player.velocity  # Assuming the player node has a velocity property
		else:
			player_velocity = Vector2.ZERO

func _on_turret_hit_box_area_entered(area):
	if area.is_in_group("missile") and area.name != "nuclear_missile_area":
		killedBy = area.get_parent()
		call_deferred("explode")  # Ensure explode is called deferred
	if area.name == "bullet_area":
		health -= 1
		if health <= 0:
			killedBy = area.get_parent()
			call_deferred("explode")

func fire_heat_seeking_missile():
	if player == null or ammo <= 0:
		return  # Ensure player is not null and ammo is available before firing

	ammo -= 1  # Decrement ammo count
	_stateMachine.travel("launchMissile")
	
	# Load the missile scene
	var missile_scene = preload("res://scenees/player and weapons/heatMissile.tscn")
	# Instantiate the missile
	var missile = missile_scene.instantiate()
	
	# Calculate the missile spawn position using the offset
	var spawn_position = global_position + Vector2(0, -200).rotated(rotation)
	missile.position = spawn_position
	missile.scale = Vector2(2, 2)
	
	# Calculate the missile velocity based on the turret's rotation
	var shoot_direction = Vector2(0, -1).rotated(rotation)
	missile.rotation = rotation
	missile.set_velocity(shoot_direction * shoot_speed)
	
	# Add the missile to the scene
	get_parent().add_child(missile)
	
	# Start reload timer if out of ammo
	if ammo <= 0:
		$Timer.start()

func explode():
	print(killedBy)
	if killedBy:
		if killedBy.has_method("add_score"):
			killedBy.add_score(2)
	var spawn_position = position + Vector2(64, 0).rotated(rotation)
	var explosion = explosion.instantiate()
	explosion.position = spawn_position
	get_parent().add_child(explosion)
	call_deferred("queue_free")

func _on_firing_area_area_entered(area):
	if area.name == "playerHitBox":
		playerInRange = true

func _on_timer_timeout():
	ammo = 1
	_stateMachine.travel("hasMissile")
	$Timer.set_wait_time(reloadWaitTime)

func _on_firing_area_area_exited(area):
	if area.name == "playerHitBox":
		playerInRange = false

func _on_turret_scan_radius_area_exited(area):
	if area.name == "playerHitBox":
		player = null
