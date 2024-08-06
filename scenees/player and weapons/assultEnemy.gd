extends Node2D

var assultMissile = preload("res://scenees/player and weapons/assultMissile.tscn")
var player
var speed = 700
var explosion_scene = preload("res://scenees/mediumExplosion.tscn")
var blackHole
var blackHoleSuction = 1500000
var dodged = false
var behavior_state = "patrol"
var dodge_direction = Vector2.ZERO
var minimum_distance = 200  # Minimum distance to maintain from other enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("player").get_node('player')
	behavior_state = "patrol"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
			# Adjust the rotation towards the black hole
		var target_rotation = suction_direction.angle()
		rotation = lerp_angle(rotation, target_rotation, 2 * delta)
		
		position += suction_direction * suction_strength * delta
	
	if behavior_state == "hunting":
		var direction_to_player = (player.global_position - global_position)
		update_raycast_target()
		check_line_of_sight(delta)
	elif behavior_state == "patrol":
		pass
	elif behavior_state == "dodging":
		dodge(delta)
	
	separate_from_enemies(delta)
		
func update_raycast_target():
	# Update the raycast direction to point towards the player
	var direction_to_player = (player.global_position - global_position)
	$RayCast2D.target_position = direction_to_player
	
	$RayCast2D.force_raycast_update()

func check_line_of_sight(delta):
	# Enable the raycast and update it
	$RayCast2D.enabled = true
	$RayCast2D.force_raycast_update()
	
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group('player'):  # Check if the collider is the player's hitbox
			move_towards_target(delta)


func move_towards_target(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		position += direction * speed * delta
		var goal_rotation = direction.angle() - Vector2(0,-1).angle()
		$Sprite2D.rotation = lerp_angle($Sprite2D.rotation, goal_rotation, 2 * delta)


func _on_hit_box_area_entered(area):
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


func explosion():
	var spawn_position = position + Vector2(64, 0).rotated(rotation)
	var explosion = explosion_scene.instantiate()
	explosion.position = spawn_position
	get_parent().add_child(explosion)
	call_deferred("queue_free")




func _on_dodge_area_area_entered(area):
	if area.is_in_group("missile"):
		behavior_state = "dodging"
		dodged = false
		
func _on_dodge_area_area_exited(area):
	if area.is_in_group("missile"):
		behavior_state = "tracking"

func dodge(delta):
	var dodge_speed = 1000
	if !dodged:
		# Randomly choose to dodge left or right
		if randi() % 2 == 0:
			dodge_direction = Vector2(0, 1)  # Dodge right
		else:
			dodge_direction = Vector2(0, -1)  # Dodge left
		dodged = true

	# Move in the dodge direction
	position += dodge_direction * dodge_speed * delta

	# Rotate to face dodge direction
	var goal_rotation = dodge_direction.angle() - Vector2(0, -1).angle()
	$Sprite2D.rotation = lerp_angle($Sprite2D.rotation, goal_rotation, 2 * delta)



func _on_sight_area_area_entered(area):
	if area.is_in_group('player'):
		behavior_state = "hunting"


func _on_sight_area_area_exited(area):
	if area.is_in_group('player'):
		behavior_state = "patrol"



func separate_from_enemies(delta):
	# Get all enemies within the same parent node
	var parent_node = get_parent()
	var enemies = parent_node.get_children()

	for enemy in enemies:
		if enemy != self and enemy.is_in_group("enemy"):
			var distance_to_enemy = global_position.distance_to(enemy.global_position)
			if distance_to_enemy < minimum_distance:
				var separation_force = (global_position - enemy.global_position).normalized()
				position += separation_force * speed * delta
