extends Node2D

@export var speed = 500  # Adjust this value as needed
var velocity = Vector2.ZERO
var time_to_explode = 5.0
var blackHole
var blackHoleSuction = 1500000
var rotation_speed = 1
var shotBy

func _ready():
	pass

func _process(delta):
	# Move the projectile based on its velocity
	position += velocity/2 * delta
	
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
			# Adjust the rotation towards the black hole
		var target_rotation = (position/delta).angle()
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
		
		position += suction_direction * suction_strength * delta
		

func set_velocity(new_velocity):
	velocity = new_velocity


func _on_bullet_area_area_entered(area):
	if area.name == "playerHitBox":
		queue_free()
	if area.name == "heatSeakingMissile" or area.name == "nuclear_missile_area" or area.name == "mediumExplosionArea":
		queue_free()
	if area.name == "turretHitBox":
		queue_free()

func setPlayer(player):
	shotBy = player
