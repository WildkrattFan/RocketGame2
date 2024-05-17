extends Node2D

# Declare turret parameters
@export var rotation_speed: float = 10.0  # Rotation speed in radians per second
@export var missile_spawn_offset: Vector2 = Vector2(0, -200)  # Offset for missile spawn point
@export var reloadWaitTime = 3.0
var shoot_speed = 4

# Declare player reference and missile spawn point
var player = null
var player_velocity: Vector2 = Vector2.ZERO
var ammo = 1

var _stateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	_stateMachine = $AnimationTree.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		# Predict the player's position based on velocity
		if player_velocity != Vector2.ZERO:
			player_velocity = player.velocity

		# Calculate the direction to the predicted position
		var direction = (player.global_position).normalized()
		
		# Calculate the target angle
		var goal_rotation = atan2(direction.x, direction.y)
		rotation = lerp_angle(rotation, goal_rotation,delta)
		

func _on_turret_scan_radius_area_entered(area):
	print("playerLocated")
	if area.name == "playerHitBox":
		player = area.get_parent()  # Assuming playerHitBox is a child of the player
		if player and "velocity" in player:
			player_velocity = player.velocity  # Assuming the player node has a velocity property
		else:
			player_velocity = Vector2.ZERO

func _on_turret_hit_box_area_entered(area):
	if area.is_in_group("missile"):
		print("poof2")
		call_deferred("explode")  # Ensure explode is called deferred

func fire_heat_seeking_missile():
	if player == null:
		return  # Ensure player is not null before firing

	_stateMachine.travel("launchMissile")
	# Load the missile scene
	var missile_scene = preload("res://scenees/player and weapons/heatMissile.tscn")
	# Instantiate the missile
	var missile = missile_scene.instantiate()
	
	# Calculate the missile spawn position using the offset
	var spawn_position = global_position + missile_spawn_offset.rotated(rotation)
	missile.position = spawn_position
	
	# Calculate the missile velocity based on the turret's rotation
	var shoot_direction = Vector2(0, -1).rotated(rotation)
	missile.set_velocity(shoot_direction * shoot_speed)
	missile.rotation = rotation
	
	# Add the missile to the scene
	get_parent().add_child(missile)
	
	# Decrement ammo count
	ammo -= 1
	
	# Start reload timer if out of ammo
	if ammo <= 0:
		$Timer.start()

	
func explode():
	print("poof!")
	# Handle turret explosion
	queue_free()  # Destroy the turret safely

func _on_firing_area_area_entered(area):
	if area.name == "playerHitBox":
		if ammo > 0:
			fire_heat_seeking_missile()
			ammo -= 1
			$Timer.start()


func _on_timer_timeout():
	ammo = 1
	_stateMachine.travel("hasMissile")
	$Timer.set_wait_time(reloadWaitTime)
