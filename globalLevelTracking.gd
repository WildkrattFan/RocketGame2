extends Node

var current_level = 1
var justPlayedLevel = 0
var previousScore = 150
var levelAbilities = []

@export var commonAbilities = ["res://scenees/ability_cards/speed_boost_card.tscn","res://scenees/ability_cards/shield.tscn"]


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
