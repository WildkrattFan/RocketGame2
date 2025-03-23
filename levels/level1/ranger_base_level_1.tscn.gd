extends Node2D

var gameOverScene = preload("res://scenees/GameOverScreen.tscn")
var pauseMenuScene = preload("res://scenees/PauseMenu.tscn")
var levelsScene = ("res://scenees/levels_screen.tscn")
var scoreScene = ("res://scenees/score_screen.tscn")
var pause_menu_instance
var paused = false
var assultEnemy = preload("res://scenees/player and weapons/assultEnemy.tscn")

var enemiesSpawned = false


@export var goal_points = 20
@export var max_time = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	$player/player.can_move = false
	State.ranger_base_computer_spoken = false
	State.ranger_spawn_enemies = false
	State.tutorial_docked = false
	State.base_in_sight_spooken = false
	#TODO: Fix
	if GlobalLevelTracking.levelAbilities:
		$player/player.setAbilityCards(GlobalLevelTracking.levelAbilities[1])
	else:
		$player/player.abilityCards = []
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State.ranger_base_computer_spoken:
		$Actionable.monitorable = false
		$Actionable.monitoring = false
		State.ranger_base_computer_spoken = true
	if State.base_in_sight_spooken:
		$try_dock.monitorable = false
		$try_dock.monitoring = false
	if State.ranger_spawn_enemies and !enemiesSpawned:
		#spawn enemies
		var enemyPosition = Vector2(-4104, -3682)
		for i in range(10):
			var enemyInstance = assultEnemy.instantiate()
			enemyPosition += Vector2(1000,-300) + Vector2(randf_range(-2000,2000),0)
			enemyInstance.position = enemyPosition
			add_child(enemyInstance)
		enemiesSpawned = true
		
	if Input.is_action_just_pressed("pause"):
		_toggle_pause_menu()

func player_explosion():
	var gameOver = gameOverScene.instantiate()
	get_parent().add_child(gameOver)
	$player.visible = false
	$player/player/CanvasLayer.visible = false
	$Actionable.close()
	$Success.close()
	$try_dock.close()
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
		
		#var timeTaken = $Timer.wait_time - $Timer.time_left
		#var time_weight = 1.0
		#var health_weight = 2.0
		#var difficulty_weight = 1.5

# Ensure positive time contribution (no negative values)
		#var time_bonus = max(max_time - timeTaken, 0) * time_weight
#
## Ensure health is non-negative
		#var health_bonus = max($player/player.health, 0) * health_weight
#
## Final score calculation
		#var score = (time_bonus + health_bonus) * (goal_points * difficulty_weight)
		
		#print("Final score: ", score)
		#
		#GlobalLevelTracking.set_previous_score(score)
		
		get_tree().change_scene_to_file(scoreScene)
		if int(GlobalLevelTracking.current_level) < 3:
			GlobalLevelTracking.set_level(3)
			GlobalLevelTracking.justPlayedLevel = 2


func _on_start_timer_timeout() -> void:
		$Portal/AnimationPlayer.play("close")
		await $Portal/AnimationPlayer.animation_finished
		$player/player.can_move = true
		$Actionable.monitorable = true
		$Actionable.monitoring = true


func _on_docking_area_area_entered(area: Area2D) -> void:
	#play animation
	if area.name == "playerHitBox":
		var player = $player/player
		player.can_move = false
		var dock_position = Vector2(25,-2924)
		var target_rotations = [90, -90]
		
		# Find the closest rotation
		var current_rotation = player.rotation_degrees
		var target_rotation = target_rotations[0] if abs(fposmod(target_rotations[0] - current_rotation + 180, 360) - 180) < abs(fposmod(target_rotations[1] - current_rotation + 180, 360) - 180) else target_rotations[1]

		var tween = player.create_tween()
		tween.tween_property(player, "rotation_degrees", target_rotation, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(player, "global_position", dock_position,1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		

		#$AnimationPlayer.play("docking")
	#have the robot talk and say successfully docking
	pass
