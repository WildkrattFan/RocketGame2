extends Node2D

var gameOverScene = preload("res://scenees/GameOverScreen.tscn")
var pauseMenuScene = preload("res://scenees/PauseMenu.tscn")
var levelsScene = ("res://scenees/levels_screen.tscn")
var scoreScene = ("res://scenees/score_screen.tscn")
var pause_menu_instance
var paused = false



@export var goal_points = 20
@export var max_time = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO: Fix
	if GlobalLevelTracking.levelAbilities:
		$player/player.setAbilityCards(GlobalLevelTracking.levelAbilities[1])
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
		if int(GlobalLevelTracking.current_level) < 3:
			GlobalLevelTracking.set_level(3)
			GlobalLevelTracking.justPlayedLevel = 2
