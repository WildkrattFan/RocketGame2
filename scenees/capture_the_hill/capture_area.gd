extends Node2D

var blueScore = 0
var redScore = 0

var blueInArea = 0
var redInArea = 0

# Load the textures
var gray_texture = preload("res://scenees/capture_the_hill/captureAreaSprites/captureTheHillAreaGray.png")
var blue_texture = preload("res://scenees/capture_the_hill/captureAreaSprites/captureTheHillAreaBlue.png")
var red_texture = preload("res://scenees/capture_the_hill/captureAreaSprites/captureTheHillAreaRed.png")
var purple_texture = preload("res://scenees/capture_the_hill/captureAreaSprites/captureTheHillAreaPurple.png")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_texture()

func update_texture():
	if blueInArea == 0 and redInArea == 0:
		$Sprite2D.texture = gray_texture
	elif blueInArea > redInArea:
		$Sprite2D.texture = blue_texture
	elif redInArea > blueInArea:
		$Sprite2D.texture = red_texture
	else:
		$Sprite2D.texture = purple_texture


func _on_capture_area_area_area_entered(area):
	if area.is_in_group("player"):
		var team = area.get_parent().team
		if team == "blue":
			blueInArea += 1
		else:
			redInArea += 1

		


func _on_capture_area_area_area_exited(area):
	if area.is_in_group("player"):
		var team = area.get_parent().team
		if team == "blue":
			blueInArea -= 1
		else:
			redInArea -= 1

func calculateWinning():
	if blueInArea > redInArea:
		return "blue"
	elif blueInArea < redInArea:
		return "red"
	else:
		return "none"


func _on_time_to_capture_timeout():
	# Update the score based on which team controls the area
	if blueInArea > redInArea:
		blueScore += 1
	elif redInArea > blueInArea:
		redScore += 1.


# You can add a function to determine the win condition, for example:
func check_win_condition():
	var winning_score = 100  # Example winning score
	if blueScore >= winning_score:
		print("Blue team wins!")
		# Trigger win logic for the blue team
	elif redScore >= winning_score:
		print("Red team wins!")
		# Trigger win logic for the red team
