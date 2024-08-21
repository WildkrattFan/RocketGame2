extends Node2D

@export var speed = 200  # Adjust this value as needed
var velocity = Vector2.ZERO
var time_to_explode = 1.5
var blackHole
var blackHoleSuction = 1500000
var rotation_speed = 2
var player
@export var tracking_speed = 1500

var shotBy

var explosion_scene = preload("res://scenees/mediumExplosion.tscn")

var _stateMachine

func _ready():
	$Timer.set_wait_time(time_to_explode)
	$Timer.start()
	_stateMachine = $Sprite2D/AnimationTree.get("parameters/playback")

func _process(delta):
	# Move the projectile based on its velocity
	position += velocity * delta
	
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
			# Adjust the rotation towards the black hole
		var target_rotation = suction_direction.angle()
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
		
		position += suction_direction * suction_strength * delta
		
	if player:
		# Calculate the direction towards the player
		if is_instance_valid(player):
			var direction_to_player = (player.global_position - global_position).normalized()
			# Calculate the velocity to move towards the player
			velocity = direction_to_player * tracking_speed
			var adjustment = Vector2(0,-1)
			# Calculate the angle to rotate towards the player
			var target_rotation = velocity.angle() - adjustment.angle()
			rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
			_stateMachine.travel("flying")
	else:
		_stateMachine.travel("engineOff")

		

func set_velocity(new_velocity):
	velocity = new_velocity




func explosion():
	var spawn_position = position + Vector2(64, 0).rotated(rotation)
	var explosion = explosion_scene.instantiate()
	explosion.position = spawn_position
	get_parent().add_child(explosion)
	explosion.setPlayer(shotBy)
	call_deferred("queue_free")
	


func _on_timer_timeout():
	call_deferred("explosion")



func _on_heat_seaking_missile_area_entered(area):
	if area.is_in_group("player"):
		call_deferred("explosion")
	if area.is_in_group("mine"):
		call_deferred("explosion")
	if area.is_in_group("missile"):
		call_deferred("explosion")
	if area.is_in_group("blackHole"):
		blackHole = area
	if area.name == "blackHoleCenter":
		call_deferred("explosion")
	if area.name == "mediumExplosionArea":
		call_deferred("explosion")
	if area.name == "turretHitBox":
		call_deferred("explosion")
	if area.name == "bullet_area":
		call_deferred("explosion")
	if area.is_in_group("Obstical"):
		call_deferred("explosion")



func _on_tracking_area_area_entered(area):
	if !player:
		if area.name == "playerHitBox":
			player = area
		if area.name == "turretHitBox":
			player = area
		if area.is_in_group("enemy"):
			player = area


func _on_tracking_area_area_exited(area):
	if area.name == "playerHitBox":
		player = null
		
func setPlayer(player):
	shotBy = player
