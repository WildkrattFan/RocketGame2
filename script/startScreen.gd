extends Control

var levels_scene = preload("res://scenees/levels_screen.tscn")
@export var player_scene = preload("res://scenees/player and weapons/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
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
	get_tree().change_scene_to_packed(levels_scene)
	
	#TODO: Implement online play!
