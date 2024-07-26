extends Node2D

var assultMissile = preload("res://scenees/player and weapons/assultMissile.tscn")
var player
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("player")
	if player:
		print("Player node found!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		update_raycast_target()
		check_line_of_sight(delta)
		
func update_raycast_target():
	# Update the raycast direction to point towards the player
	var direction_to_player = (player.global_position - global_position)
	print("direction updated")
	$RayCast2D.target_position = direction_to_player
	$RayCast2D.force_update_transform()
	$RayCast2D.force_raycast_update()
	print("raycast updated to" + str(direction_to_player))

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
