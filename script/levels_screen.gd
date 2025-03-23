extends Control
var startScene = ("res://scenees/startScreen.tscn")

var level_list = [("res://levels/tutorial_level/tutorial_level.tscn"),("res://levels/level1/level1.tscn"),("res://scenees/demo_levels/level3.tscn")]
var save_path = "user://score.save"



var level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_score()
	level = GlobalLevelTracking.current_level
	print("readying up!")
	print(GlobalLevelTracking.current_level)
	print(level)
	var level_button_list = $level_buttons.get_children()
	
	for i in range (level_button_list.size()):
		if i <= int(GlobalLevelTracking.current_level)-1:
			level_button_list[i].disabled = false
			level_button_list[i].modulate = Color(1, 1, 1)  # Normal color
		else:
			level_button_list[i].disabled = true
			level_button_list[i].modulate = Color(0.5, 0.5, 0.5)  # Gray out the button



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if level != GlobalLevelTracking.current_level:
		_on_level_changed()
	


func _on_back_bttn_button_down() -> void:
	get_tree().change_scene_to_file(startScene)



func switchScene(scene):
	get_tree().change_scene_to_file(scene)


func _on_level_1_button_down() -> void:
	switchScene(level_list[0])


func _on_level_2_button_down() -> void:
	switchScene(level_list[1])


func _on_level_3_button_down() -> void:
	switchScene(level_list[2])
	
func _on_level_changed():
	var level_button_list = $level_buttons.get_children()
	
	for i in range (level_button_list.size()):
		if i <= GlobalLevelTracking.current_level-1:
			level_button_list[i].disabled = false
			level_button_list[i].modulate = Color(1, 1, 1)  # Normal color
		else:
			level_button_list[i].disabled = true
			level_button_list[i].modulate = Color(0.5, 0.5, 0.5)  # Gray out the button
	level = GlobalLevelTracking.current_level
	save_score()


func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(GlobalLevelTracking.current_level)
	file.store_var(GlobalLevelTracking.levelAbilities)

	
