extends Node

var current_level = 1

var previousScore = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_level(num):
	current_level = num

func set_previous_score(num):
	previousScore = num
