extends Node2D

var redTeamCount = 0
var blueTeamCount = 0
var goalScore = 100

var player_scene = preload("res://scenees/player and weapons/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/blueTeamProgressBar.value = 0
	$CanvasLayer/redTeamProgressBar.value = 0
	$CanvasLayer/blue_red.text =(str(0) + "/" + str(0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var redTeamScore = $CaptureArea.redScore
	var blueTeamScore = $CaptureArea.blueScore
	$CanvasLayer/blueTeamProgressBar.value = (float(blueTeamScore) / float(goalScore)) * 100
	$CanvasLayer/redTeamProgressBar.value = (float(redTeamScore) / float(goalScore)) * 100
	$CanvasLayer/blue_red.text =(str(blueTeamScore) + "/" + str(redTeamScore))

func newPlayer():
	if redTeamCount > blueTeamCount:
		addBluePlayer()
	elif redTeamCount < blueTeamCount:
		addRedPlayer()
	else:
		# Randomly choose a team if both teams are equal
		var random_team = randi() % 2
		if random_team == 0:
			addBluePlayer()
		else:
			addRedPlayer()

func addBluePlayer():
	# Instantiate the player
	var player = player_scene.instantiate()
	
	# Assign the player to the blue team
	player.team = "blue"
	player.modulate = Color(0, 0, 1)  # Set player color to blue
	
	# Set the player's initial position
	player.position = get_spawn_position("blue")

	# Add the player to the scene
	add_child(player)

	# Increment the blue team count
	blueTeamCount += 1

func addRedPlayer():
	# Instantiate the player
	var player = player_scene.instantiate()
	
	# Assign the player to the red team
	player.team = "red"
	player.modulate = Color(1, 0, 0)  # Set player color to red
	
	# Set the player's initial position
	player.position = get_spawn_position("red")

	# Add the player to the scene
	add_child(player)

	# Increment the red team count
	redTeamCount += 1

func get_spawn_position(team):
	# Logic to determine the spawn position based on the team
	if team == "blue":
		return Vector2(100, 100)  # Replace with actual blue team spawn position
	else:
		return Vector2(900, 100)  # Replace with actual red team spawn position
