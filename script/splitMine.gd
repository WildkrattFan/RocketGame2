extends Node2D

# Variables
var player
var smaller_mine_scene = preload("res://scenees/player and weapons/mine.tscn")
var health = 3
var blackHole
var blackHoleSuction = 1500000

func _ready():
	pass

func _process(delta):
	if blackHole:
		var suction_direction = (blackHole.global_position - global_position).normalized()
		var distance_to_black_hole = global_position.distance_to(blackHole.global_position)
		var suction_strength = blackHoleSuction / distance_to_black_hole
		position += suction_direction * suction_strength * delta


func spawn_smaller_mines():
	for i in range(8):
		var smaller_mine = smaller_mine_scene.instantiate()
		var random_offset = Vector2(randf_range(-350, 350), randf_range(-350, 350))
		smaller_mine.global_position = global_position + random_offset
		# Add randomness to smaller mines direction
		
		get_parent().add_child(smaller_mine)
		queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		spawn_smaller_mines()
	if area.is_in_group("missile"):
		health -= 1
		if health <= 0:
			spawn_smaller_mines()
	if area.is_in_group("blackHole"):
		blackHole = area
	if area.name == "blackHoleCenter":
		print("entering the center...")
		spawn_smaller_mines()
