extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	print("resuming")


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenees/startScreen.tscn")
	queue_free()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_resume_button_button_down() -> void:
	visible = false
	get_tree().paused = false
	print("resuming")
