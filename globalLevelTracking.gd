extends Node

var current_level: int = 1
var justPlayedLevel: int = 0
var previousScore: int = 4
var levelAbilities = []

@export var commonAbilities = ["res://scenees/ability_cards/shield.tscn", "res://scenees/ability_cards/emp_card.tscn", "res://scenees/ability_cards/tripple_missile.tscn", "res://scenees/ability_cards/mine_card.tscn"]
var rareAbilities = ["res://scenees/ability_cards/speed_boost_card.tscn"]
var epicAbilities = ["res://scenees/ability_cards/time_slow_card.tscn","res://scenees/ability_cards/ghost_card.tscn"]
var legendaryAbilities = ["res://scenees/ability_cards/singularity_bomb_card.tscn"]
var mythicAbilities = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levelAbilities.resize(20)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_level(num):
	current_level = num

func set_previous_score(num):
	previousScore = num
