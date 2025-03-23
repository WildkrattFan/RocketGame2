extends Node

var has_shot = false

var playerName = ""
var levels_scene = ("res://scenees/levels_screen.tscn")
var player_enterInput = false
var jaxson_enters = false
var can_move
var ranger_base_computer_spoken = false
var ranger_spawn_enemies = false

var tutorial_docked = false
var base_in_sight_spooken = false

func endTutorial():
	if int(GlobalLevelTracking.current_level) < 2:
		GlobalLevelTracking.set_level(2)
		GlobalLevelTracking.justPlayedLevel = 1
	get_tree().change_scene_to_file(levels_scene)
	
func switch_to_scene(scene):
	get_tree().change_scene_to_file(scene)

func jaxson_enter():
	jaxson_enters = true
	
func set_player_can_move():
	can_move = true
#Level 1 intro
