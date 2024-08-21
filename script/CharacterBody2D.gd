extends CharacterBody2D

var assultMissile = preload("res://scenees/player and weapons/assultMissile.tscn")
var player
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("player")
	if player:
		print("Player node found!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		$NavigationAgent2D.target_position  = player.global_position
		print(player.global_position)
		moveTowardsTarget(delta)
		
func moveTowardsTarget(delta):
	if not $NavigationAgent2D.is_navigation_finished():
		var next_position = $NavigationAgent2D.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		var velocity = direction * speed * delta
		move_and_slide()
