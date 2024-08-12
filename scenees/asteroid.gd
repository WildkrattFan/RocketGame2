extends Node2D

var randomScale
var health
var randomDirection = Vector2.ZERO
var randomSpeed
var randomRotation
var randomRotatation_speed


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


func _on_hitbox_area_entered(area):

	if area.is_in_group("Obstical"):
		health -= 10
		randomDirection = -randomDirection
		randomRotatation_speed = -randomRotatation_speed
		
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

func split():
	pass
