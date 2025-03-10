extends Control

var levels_scene = ("res://scenees/levels_screen.tscn")
@export var player_scene = preload("res://scenees/player and weapons/Player.tscn")

var save_path = "user://score.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_score()
	pass
	
func _process(delta: float) -> void:
	
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
		
	#Music from #Uppbeat (free for Creators!):
	#https://uppbeat.io/t/simon-folwar/neon-signs
	#License code: QFOIC2KZCJDRWPGA

func _on_controls_button_button_down():
	$controlsPopup.visible = true

func _on_host_pressed():
	$hostPopup.visible = true

func _on_play_pressed():
	print("switching scenes")
	get_tree().change_scene_to_file(levels_scene)
	
	#TODO: Implement online play!


func load_score():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		GlobalLevelTracking.current_level = file.get_var()
		GlobalLevelTracking.levelAbilities = file.get_var(true)

		
		if !GlobalLevelTracking.current_level:
			GlobalLevelTracking.current_level = 1
		if !GlobalLevelTracking.levelAbilities:
			GlobalLevelTracking.levelAbilities = []
			
		print("current level", int(GlobalLevelTracking.current_level))
		print("level abilities", (GlobalLevelTracking.levelAbilities))
	else:
		print("file not found")
		GlobalLevelTracking.current_level = 1
		GlobalLevelTracking.levelAbilities = []
