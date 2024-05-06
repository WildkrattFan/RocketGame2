extends Camera2D

# Adjust these variables as needed
var smoothness = 5.0
var minX = 0
var minY = 0
var maxX = 1920  # Replace with your screen width
var maxY = 1080  # Replace with your screen height

func _process(delta):
	# Get player position
	var player_pos = get_node("player").global_position  # Assuming the player node is a child of the camera

	# Clamp camera position to screen boundaries
	var target_pos = player_pos.clamped(Vector2(minX, minY), Vector2(maxX, maxY))

	# Smoothly move the camera towards the target position
	position = position.lerp(target_pos, smoothness * delta)
	
