extends Node2D

@export var speed = 200  # Adjust this value as needed
var velocity = Vector2.ZERO
var time_to_explode = 5.0
var blackHole
var blackHoleSuction = 1500000
var rotation_speed = 1
var player
@export var tracking_speed = 500
var shotBy

var explosion_scene = preload("res://scenees/mediumExplosion.tscn")

var _stateMachine

func _ready():
	$Timer.set_wait_time(time_to_explode)
	$Timer.start()

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
		
func setPlayer(player):
	shotBy = player

func set_velocity(new_velocity):
	velocity = new_velocity




func explosion():
	var spawn_position = position + Vector2(64, 0).rotated(rotation)
	var explosion = explosion_scene.instantiate()
	explosion.position = spawn_position
	explosion.scale = Vector2(10,10)
	explosion.setPlayer(shotBy)
	get_parent().add_child(explosion)
	queue_free()
	


func _on_timer_timeout():
	explosion()







func _on_nuclear_missile_area_area_entered(area):
	if area.name == "bullet_area":
		queue_free()
	if area.name == "playerHitBox":
		queue_free()
	if area.name == "heatSeakingMissile":
		queue_free()
	if area.name == "turretHitBox":
		queue_free()
	if area.is_in_group("Obstical"):
		queue_free()
