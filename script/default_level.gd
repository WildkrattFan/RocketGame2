extends Node2D

var gameOverScene = preload("res://scenees/GameOverScreen.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_explosion():
	print("explosion recieved")
	var gameOver = gameOverScene.instantiate()
	get_parent().add_child(gameOver)
	$player.visible = false


func _on_player_main_player_exploded():
	player_explosion()
