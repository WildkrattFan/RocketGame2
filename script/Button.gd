extends Button

# Called when the button is pressed.
func _on_pressed():
	# Implement respawn logic here
	# For example, reset player position and health
	var player = get_node("/root/Player")  # Assuming your player node is named "Player" and it's located at the root of the scene tree
	var respawn_position = Vector2(1000, 1000)  # Example respawn position, adjust as needed
	
	# Reset player position
	if player != null:
		player.position = respawn_position
		
	# Reset player health (if applicable)
	# player.health = player.max_health  # Assuming the player has health properties
	
	# Reset any other relevant player state
	
	# Reload the current scene to restart the game
	get_tree().change_scene_to_file("res://scenees/space.tscn")
