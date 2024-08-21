extends Control
var startScene = preload("res://scenees/startScreen.tscn")

var level_list = [preload("res://scenees/demo_levels/level1.tscn"),preload("res://scenees/demo_levels/level2.tscn"),preload("res://scenees/demo_levels/level3.tscn")]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_bttn_button_down() -> void:
	switchScene(startScene)



func switchScene(scene):
	get_tree().change_scene_to_packed(scene)


func _on_level_1_button_down() -> void:
	switchScene(level_list[0])


func _on_level_2_button_down() -> void:
	switchScene(level_list[1])


func _on_level_3_button_down() -> void:
	switchScene(level_list[2])
