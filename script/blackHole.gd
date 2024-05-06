extends Node2D

# Properties
@export var min_orbit_radius = 2000
@export var max_orbit_radius = 4000
@export var min_orbit_speed = 0.01
@export var max_orbit_speed = 0.03
@export var min_scale = 0.5
@export var max_scale = 5

var current_angle = 0
var center_position = Vector2.ZERO
var orbit_radius = 0
var orbit_speed = 0

func _ready():
	# Set the initial center position
	var randomSize =  RandomNumberGenerator.new()
	randomSize.seed = randi()
	center_position = global_position
	
	# Randomize the orbit radius and speed
	orbit_radius = randf_range(min_orbit_radius, max_orbit_radius)
	orbit_speed = randf_range(min_orbit_speed, max_orbit_speed)
	var randomScale = randomSize.randf_range(min_scale, max_scale)
	scale = Vector2(randomScale, randomScale)
	
	# Randomize the orbit direction
	if randf() < 0.5:
		orbit_speed *= -1  # Reverse the orbit direction

func _process(delta):
	# Calculate the new position based on the orbit
	current_angle += orbit_speed * delta
	var x = center_position.x + orbit_radius * cos(current_angle)
	var y = center_position.y + orbit_radius * sin(current_angle)
	global_position = Vector2(x, y)
