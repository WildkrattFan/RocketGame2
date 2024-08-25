extends Control

signal resumeButton
var player_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		resume()


func _on_resume_button_pressed() -> void:
	resume()


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenees/startScreen.tscn")
	resume()
	queue_free()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	resume()
	queue_free()

#TODO: Implement
func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func addPlayer(player):
	player_node = player

func resume():
	queue_free()
	get_tree().paused = false
	
	if player_node:
		player_node.visible = true
		player_node.get_node("player").get_node("CanvasLayer").visible = true
