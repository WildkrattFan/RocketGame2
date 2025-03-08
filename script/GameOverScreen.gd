extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Respawn Button
func _on_button_pressed():
	# Reload the current scene to restart the game
	get_tree().reload_current_scene()
	get_tree().paused = false
	queue_free()


#Back to menu button
func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenees/startScreen.tscn")
	get_tree().paused = false
	queue_free()
