extends Node2D

var gameOverScene = preload("res://scenees/GameOverScreen.tscn")
var pauseMenuScene = preload("res://scenees/PauseMenu.tscn")
var levelsScene = ("res://scenees/levels_screen.tscn")
var nextScene = ("res://levels/level1/level1.tscn")
var scoreScene = ("res://scenees/score_screen.tscn")
var pause_menu_instance
var paused = false

var name_input_layer
var name_input
var playerEntering = false

@export var goal_points = 6
@export var max_time = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	State.has_shot = false
	#TODO: Fix
	if GlobalLevelTracking.levelAbilities:
		$player/player.setAbilityCards(GlobalLevelTracking.levelAbilities[0])
	else:
		$player/player.abilityCards = []
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_toggle_pause_menu()


func player_explosion():
	var gameOver = gameOverScene.instantiate()
	get_parent().add_child(gameOver)
	$player.visible = false
	$player/player/CanvasLayer.visible = false
	$Actionable.close()
	get_tree().paused  = true


func _on_player_main_player_exploded():
	Engine.time_scale = 1.0
	player_explosion()

func _toggle_pause_menu():
	pause_menu_instance = pauseMenuScene.instantiate()
	get_parent().add_child(pause_menu_instance)
	pause_menu_instance.addPlayer($player)
	$player.visible = false
	$player/player/CanvasLayer.visible = false
	get_tree().paused  = true
	paused = true


func _on_player_main_points_added() -> void:
	print($player/player.get_points())
	if $player/player.get_points() >= goal_points:
		var timeTaken = $Timer.wait_time - $Timer.time_left
		var time_weight = 1.0
		var health_weight = 2.0
		var difficulty_weight = 1.5

# Ensure positive time contribution (no negative values)
		var time_bonus = max(max_time - timeTaken, 0) * time_weight

# Ensure health is non-negative
		var health_bonus = max($player/player.health, 0) * health_weight

# Final score calculation
		var score = (time_bonus + health_bonus) * (goal_points * difficulty_weight)
		
		print("Final score: ", score)
		
		GlobalLevelTracking.set_previous_score(score)
		
		get_tree().change_scene_to_file(scoreScene)
		if int(GlobalLevelTracking.current_level) < 2:
			GlobalLevelTracking.set_level(2)
			GlobalLevelTracking.justPlayedLevel = 1


func _on_missile_recognition_area_entered(area: Area2D) -> void:
	if(area.is_in_group("missile")):
		State.has_shot = true

func _create_name_input():
	# Create a CanvasLayer for UI
	name_input_layer = CanvasLayer.new()
	add_child(name_input_layer)

	# Create a Control node to hold UI elements
	var control = Control.new()
	control.anchor_right = 1
	control.anchor_bottom = 1
	control.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	control.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	control.size = Vector2(300, 120)
	control.position = Vector2(get_viewport_rect().size.x / 2 - 150, get_viewport_rect().size.y / 2 - 60)
	name_input_layer.add_child(control)

	# Create a label
	var label = Label.new()
	label.text = "Enter Your Name:"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control.add_child(label)

	# Create an input field
	name_input = LineEdit.new()
	name_input.placeholder_text = "Type your name..."
	name_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_input.size = Vector2(280, 30)
	control.add_child(name_input)

	# Create a submit button
	var submit_button = Button.new()
	submit_button.text = "Submit"
	submit_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	submit_button.size = Vector2(280, 30)
	submit_button.pressed.connect(_on_name_submitted)
	control.add_child(submit_button)

	# Adjust positioning
	label.position = Vector2(10, 10)
	name_input.position = Vector2(10, 40)
	submit_button.position = Vector2(10, 80)

func _on_name_submitted():
	var player_name = name_input.text.strip_edges()
	if player_name != "":
		print("Player Name:", player_name)
		State.playerName = player_name
		name_input_layer.queue_free()  # Remove input layer after submission
	else:
		print("Please enter a valid name!")
