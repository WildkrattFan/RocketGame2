extends Node2D

var player = null;
var _stateMachine
var exploded = false
var rarity = "common"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_stateMachine = $AnimationTree.get("parameters/playback")
	$Sprite2D2.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func use(delta,player):
	$Sprite2D2.visible = true
	var root = get_tree().current_scene  # The main scene root
	get_parent().remove_child(self)  # Remove from current parent
	root.add_child(self)  # Add to the main scene
	global_position = player.global_position
	_stateMachine.travel("explode")
	await $AnimationPlayer.animation_finished
	queue_free()
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	print(parent)
	if parent.has_method("short_circut"):
		print("it has the method!!!!")
		parent.short_circut()
