extends Node2D

var gameOverScene = preload("res://scenees/GameOverScreen.tscn")
var pauseMenuScene = preload("res://scenees/PauseMenu.tscn")
var pause_menu_instance
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
	player_explosion()

func _toggle_pause_menu():
	pause_menu_instance = pauseMenuScene.instantiate()
	get_parent().add_child(pause_menu_instance)
	pause_menu_instance.addPlayer($player)
	$player.visible = false
	$player/player/CanvasLayer.visible = false
	get_tree().paused  = true
	paused = true
