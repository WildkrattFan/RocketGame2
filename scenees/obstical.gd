extends Node2D

var randomScale
var health
var randomDirection = Vector2.ZERO
var randomSpeed
var randomRotation
var randomRotatation_speed
var blackHole
var blackHoleSuction = 1500000

# Called when the node enters the scene tree for the first time.
func _ready():
	randomScale = randf_range(1,15)
	scale.x = randomScale
	scale.y = randomScale
	health = randomScale * 10
	randomDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	randomSpeed = randf_range(0,3)
	randomRotation = randf_range(0,359)
	rotation = randomRotation
	
	randomRotatation_speed = randf_range(-.002,.002)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += randomDirection
	rotation += randomRotatation_speed
	
	
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
			# Adjust the rotation towards the black hole
		#var target_rotation = suction_direction.angle()
		#$Sprite2D.rotation = lerp_angle(rotation, target_rotation, 2 * delta)
		
		position += suction_direction * suction_strength * delta


func _on_hitbox_area_entered(area):

	if area.is_in_group("Obstical"):
		health -= 10
		randomDirection = -randomDirection
		randomRotatation_speed = -randomRotatation_speed
		
	elif area.name == "pearcing_missile":
		health -=10
		
	elif area.is_in_group("missile") & area.name != "nuclear_missile_area" :
		health -= 15
		
	elif area.name == "nuclear_missile_area":
		health -= 1
		
	if area.name == "bullet_area":
		health -= 1
	if area.is_in_group("blackHole"):
		blackHole = area
		
	if area.name == "blackHoleCenter":
		health = 0
	if area.name == "hitBox":
		health -= 10
	split(area)

func split(area):
	print(health)
	#TODO: complete the split function if needed
	if health <= 0:
		queue_free()
	pass
