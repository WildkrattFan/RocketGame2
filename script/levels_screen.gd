extends Control
var startScene = preload("res://scenees/startScreen.tscn")

var level_list = [preload("res://scenees/demo_levels/level1.tscn"),preload("res://scenees/demo_levels/level2.tscn"),preload("res://scenees/demo_levels/level3.tscn")]

var current_level = GlobalLevelTracking.current_level



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var level_button_list = $level_buttons.get_children()
	
	for i in range (level_button_list.size()):
		if i <= current_level-1:
			level_button_list[i].disabled = false
			level_button_list[i].modulate = Color(1, 1, 1)  # Normal color
		else:
			level_button_list[i].disabled = true
			level_button_list[i].modulate = Color(0.5, 0.5, 0.5)  # Gray out the button



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_bttn_button_down() -> void:
	get_tree().change_scene_to_packed(startScene)



func switchScene(scene):
	get_tree().change_scene_to_packed(scene)


func _on_level_1_button_down() -> void:
	switchScene(level_list[0])


func _on_level_2_button_down() -> void:
	switchScene(level_list[1])


func _on_level_3_button_down() -> void:
	switchScene(level_list[2])
