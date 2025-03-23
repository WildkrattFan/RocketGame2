extends Node2D

var randomScale
var max_health 
var health
var randomDirection = Vector2.ZERO
var randomSpeed
var randomRotation
var randomRotatation_speed
var blackHole
var blackHoleSuction = 1500000
var _stateMachine

var obstical_scene = preload("res://scenees/split_obstical.tscn")



var has_split = false
# Called when the node enters the scene tree for the first time.
func _ready():
	randomScale = randf_range(1,6)
	scale.x = randomScale
	scale.y = randomScale
	health = randomScale * 10
	max_health = health
	randomDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	randomSpeed = randf_range(0,35) / randomScale
	randomRotation = randf_range(0,359)
	rotation = randomRotation
	
	randomRotatation_speed = randf_range(-.002,.002)
	_stateMachine = $Sprite2D/AnimationTree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += randomDirection * randomSpeed
	rotation += randomRotatation_speed
	
	#Handles blackhole logic
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
			# Adjust the rotation towards the black hole
		var target_rotation = suction_direction.angle()
		rotation = lerp_angle(rotation, target_rotation, 2 * delta)
		
		position += suction_direction * suction_strength * delta



func _on_hitbox_area_entered(area):

	if area.is_in_group("Obstical"):
		health -= 10
		randomDirection = -randomDirection
		randomRotatation_speed = -randomRotatation_speed
		
	elif area.name == "pearcing_missile":
		health -=10
		
	elif area.is_in_group("missile") and area.name != "nuclear_missile_area" :
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
	if area.is_in_group("explosion"):
		health -=5
	split(area)

func split(area):
	#TODO: complete the split function if needed
	var health_percent = health / max_health
	
	if health_percent <= 0 and not has_split:
		randomDirection = randomDirection * 0
		_stateMachine.travel("destruction")
		var split_parts_num = randf_range(2,4)
		var new_scale = scale / split_parts_num
		var split_counter = 0
		#$Sprite2D/hitbox/CollisionPolygon2D.disabled = true
		for i in range(split_parts_num):
			split_counter += 1
			var split_instance = obstical_scene.instantiate()
			split_instance.position = position + Vector2(randf_range(scale.x * 100, scale.x * 200 ),randf_range(scale.y * 100, scale.y * 200))
			split_instance.scale = new_scale
			get_parent().call_deferred("add_child",split_instance)
			queue_free()
		has_split = true
			
		
	elif health_percent <= 0.2:
		_stateMachine.travel("20")
	elif health_percent <= 0.4:
		_stateMachine.travel("40")
	elif health_percent <= 0.6:
		_stateMachine.travel("60")
	elif health_percent <= 0.8:
		_stateMachine.travel("80")
	

#Removes the obstical from the scene once destroyed
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "destruction":
		queue_free()
		
		

	
