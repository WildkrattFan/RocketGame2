extends Node2D

# Define properties
var min_split_size = 20
var max_split_size = 40
var split_speed = 100
var disappear_size = 10

# Define methods
func _ready():
	# Initialize asteroid properties
	set_process(true)

func _process(delta):
	# Check if asteroid reached disappear size
	#if get_radius() < disappear_size:
		#queue_free()
	pass

func _on_asteroid_area_entered(area):
	# Check if area is an explosion or missile
	if area.has_method("explode"):
		# Split the asteroid
		split_asteroid()

func split_asteroid():
	# Check if asteroid size is greater than minimum split size
	if get_radius() > min_split_size:
		# Calculate number of splits
		var num_splits = randf_range(2, 4)
		
		# Spawn smaller asteroids
		for i in range(num_splits):
			var new_asteroid = preload("res://scenees/asteroid.tscn").instantiate()
			new_asteroid.position = position
			new_asteroid.set_linear_velocity(Vector2(randf_range(-split_speed, split_speed), randf_range(-split_speed, split_speed)))
			get_parent().add_child(new_asteroid)
	
	# Destroy current asteroid
	queue_free()

func get_radius():
	# Return radius of asteroid (assuming it's a circle)
	return max(global_position.distance_to(position), global_scale.x, global_scale.y)


func _on_asteroid_area_area_entered(area):
	pass # Replace with function body.
