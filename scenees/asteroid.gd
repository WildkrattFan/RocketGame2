extends Node2D

var asteroidScene = preload("res://scenees/asteroid.tscn")

var health
var randomSpeed
var randomRotation
var randomRotatation_speed

var randomDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1))

var lower_size = 1
var upper_size = 15
var randomScale = randf_range(lower_size,upper_size)


# Called when the node enters the scene tree for the first time.
func _ready():
	scale.x = randomScale
	scale.y = randomScale
	health = randomScale * 10
	randomSpeed = randf_range(0,3)
	randomRotation = randf_range(0,359)
	rotation = randomRotation
	
	randomRotatation_speed = randf_range(-.002,.002)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += randomDirection
	rotation += randomRotatation_speed


func _on_hitbox_area_entered(area):

	if area.is_in_group("Obstical"):
		split(area)
		
	elif area.name == "pearcing_missile":
		health -=10
		
	elif area.name == "missile":
		health -= 3
		
	elif area.name == "nuclear_missile_area":
		health -= 1
		
	if area.name == "bullet_area":
		health -= 1
		
		
	#if area.is_in_group("blackHole"):
		#blackHole = area
		
	if area.name == "blackHoleCenter":
		health -= 100
	if area.name == "hitBox":
		health -= 100

func split(area):
	var asteroid = area.get_parent()
	var asteroid_size = asteroid.scale.x
	
	if asteroid_size > randomScale:
		var split_count = ceil(asteroid_size / randomScale)
		var split_lower_size = lower_size / split_count
		var split_uper_size = upper_size / split_count
		
		for i in range(split_count):
			var new_asteroid = asteroidScene.instantiate()

			var new_scale = randf_range(split_lower_size,split_uper_size)
			new_asteroid.scale = Vector2(new_scale, new_scale)
			
			var split_direction = -randomDirection 
			
			# Set the position slightly offset from the original
			var offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
			new_asteroid.position = position + offset
		
			get_parent().add_child(new_asteroid)
			
			queue_free()
	else:
		pass

