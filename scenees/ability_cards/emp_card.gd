extends Node2D

var player = null;
var _stateMachine
var exploded = false
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
	global_position = player.global_position
	_stateMachine.travel("explode")
	pass
	
