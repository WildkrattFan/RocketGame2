extends Control

var textNum = 0
var nextAbilities = []
var rng = RandomNumberGenerator.new()
var save_path = "user://score.save"


func _ready() -> void:
	while textNum < GlobalLevelTracking.previousScore:
		textNum += 1
		$Score.text = "Final Score: " + str(textNum)
		await get_tree().create_timer(0.001).timeout
	openChest()

func openChest():
	rng.randomize()

	if GlobalLevelTracking.previousScore > 500:
		var randomNum = rng.randi_range(5,8)
		getAbilities(randomNum, GlobalLevelTracking.epicAbilities + GlobalLevelTracking.legendaryAbilities)
	elif GlobalLevelTracking.previousScore > 400:
		var randomNum = rng.randi_range(4,6)
		getAbilities(randomNum, GlobalLevelTracking.rareAbilities + GlobalLevelTracking.legendaryAbilities)
	elif GlobalLevelTracking.previousScore > 300:
		var randomNum = rng.randi_range(3,5)
		getAbilities(randomNum, GlobalLevelTracking.commonAbilities + GlobalLevelTracking.epicAbilities)
	elif GlobalLevelTracking.previousScore > 200:
		var randomNum = rng.randi_range(2,4)
		getAbilities(randomNum, GlobalLevelTracking.commonAbilities + GlobalLevelTracking.rareAbilities)
	else:
		var randomNum = rng.randi_range(1,3)
		getAbilities(randomNum, GlobalLevelTracking.commonAbilities)

func getAbilities(count, abilityPool):
	for i in range(count):
		var randomIndex = rng.randi_range(0, abilityPool.size() - 1)
		var newAbility = abilityPool[randomIndex]
		nextAbilities.append(newAbility)

	GlobalLevelTracking.levelAbilities[GlobalLevelTracking.justPlayedLevel + 1] = nextAbilities
	# Output the selected abilities (for debugging or display)
	print("Abilities received: ", nextAbilities)
