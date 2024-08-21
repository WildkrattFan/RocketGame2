extends Node2D

var gameOverScene = preload("res://scenees/GameOverScreen.tscn")
var pauseMenuScene = preload("res://scenees/PauseMenu.tscn")
var pause_menu_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu_instance = pauseMenuScene.instantiate()
	add_child(pause_menu_instance)
	pause_menu_instance.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_toggle_pause_menu()

func player_explosion():
	var gameOver = gameOverScene.instantiate()
	get_parent().add_child(gameOver)
	$player.visible = false
	$player/player/CanvasLayer.visible = false


func _on_player_main_player_exploded():
	player_explosion()

func _toggle_pause_menu():
	if pause_menu_instance.visible:
		pause_menu_instance.visible = false
		get_tree().paused = false
	else:
		pause_menu_instance.visible = true
		get_tree().paused = true
