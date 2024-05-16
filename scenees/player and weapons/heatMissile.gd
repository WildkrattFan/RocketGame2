extends Node2D

@export var speed = 200  # Adjust this value as needed
var velocity = Vector2.ZERO
var time_to_explode = 5.0
var blackHole
var blackHoleSuction = 1500000
var rotation_speed = 1000
var player
@export var tracking_speed = 7000

var explosion_scene = preload("res://scenees/mediumExplosion.tscn")

var _stateMachine

func _ready():
	$Timer.set_wait_time(time_to_explode)
	$Timer.start()
	_stateMachine = $Sprite2D/AnimationTree.get("parameters/playback")

func _process(delta):
	# Move the projectile based on its velocity
	position += velocity/5 * delta
	
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
			# Adjust the rotation towards the black hole
		var target_rotation = (position/delta).angle()
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
		
		position += suction_direction * suction_strength * delta
		
	if player:
# Calculate the direction towards the player
		var direction_to_player = (player.global_position - global_position).normalized()
		# Calculate the angle to rotate towards the player
		var goal_rotation = direction_to_player.angle() * 180 / PI
		rotation = lerp_angle(rotation, goal_rotation,delta)
		# Calculate the velocity to move towards the player
		velocity = direction_to_player * tracking_speed
		_stateMachine.travel("flying")
	else:
		rotation = rotation
		_stateMachine.travel("engineOff")
		

func set_velocity(new_velocity):
	velocity = new_velocity




func explosion():
	var spawn_position = position + Vector2(64, 0).rotated(rotation)
	var explosion = explosion_scene.instantiate()
	explosion.position = spawn_position
	get_parent().add_child(explosion)
	queue_free()
	


func _on_timer_timeout():
	explosion()



func _on_heat_seaking_missile_area_entered(area):
	if area.is_in_group("player"):
		explosion()
	if area.is_in_group("mine"):
		explosion()
	if area.is_in_group("missile"):
		explosion()
	if area.is_in_group("blackHole"):
		blackHole = area
	if area.name == "blackHoleCenter":
		explosion()
	if area.name == "mediumExplosionArea":
		explosion()




func _on_tracking_area_area_entered(area):
	if area.name == "playerHitBox":
		player = area
		print("player!!")


func _on_tracking_area_area_exited(area):
	if area.name == "playerHitBox":
		player = null
