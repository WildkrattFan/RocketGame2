extends Node2D

# Variables
var player
var shooter = null
var attraction_force = 300

# Define variables for explosions
var _mediumExplosion : Area2D
var _smallExplosion : Area2D
var _wideExplosion : Area2D
var isExploding = false
var blackHole
var blackHoleSuction = 1500000
var explosion_scene = preload("res://scenees/mediumExplosion.tscn")

func _ready():
	pass

func _process(delta):
	# Move the mine towards the player
	
	if player: 
		var direction = (player.global_position - global_position).normalized()
		var shipRotation = (direction/delta).angle()
		
		position += direction * attraction_force * delta
		# Increase flash speed as remaining time decreases
		var flashSpeed = 1.0 / $Timer.time_left
		# Calculate red component based on flash speed
		var red = clamp(flashSpeed * 3, 0.0, 1.0)
		# Set modulation color to red with dynamic intensity
		modulate = Color(red, 0.0, 0.0, 1.0)


	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
		position += suction_direction * suction_strength * delta

func explode():
	isExploding = true
	var spawn_position = position + Vector2(64, 0).rotated(rotation)
	var explosion = explosion_scene.instantiate()
	explosion.position = spawn_position
	get_parent().add_child(explosion)
	explosion.setPlayer(shooter)
	queue_free()
	
	# Set monitorable to true when the mine explodes

func _on_timer_timeout():

	# Pass delta as an argument to explode function
	explode()

func _on_area_2d_2_area_entered(area):
	if area.is_in_group("enemy"):
		
		# Set the player reference
		player = area
		# Start the timer when the player enters the area
		$Timer.set_wait_time(5.0)
		$Timer.start()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		# Pass delta as an argument to explode function
		explode()
	if area.is_in_group("player"):
		explode()
	if(area.is_in_group("obstical")):
		explode()
	if area.is_in_group("missile"):
		# Pass delta as an argument to explode function
		explode()
	if area.is_in_group("mine"):
		# Pass delta as an argument to explode function
		explode()
	if area.is_in_group("blackHole"):
		blackHole = area
	if area.name == "blackHoleCenter":
		explode()
	


func _on_attraction_area_area_exited(area):
	if area.is_in_group("player"):
		player = null
