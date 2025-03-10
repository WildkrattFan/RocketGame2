extends Control

var textNum = 0
var nextAbilities = []
var rng = RandomNumberGenerator.new()
var save_path = "user://score.save"
var levels_scene = ("res://scenees/levels_screen.tscn")
var _portalMachine


func _ready() -> void:
	while textNum < GlobalLevelTracking.previousScore:
		textNum += 1
		$Score.text = "Final Score: " + str(textNum)
		$portal.visible = false
		$CenterContainer/Levels_bttn.visible = false
		await get_tree().create_timer(0.001).timeout
		_portalMachine = $AnimationTree2.get("parameters/playback")
	openChest()

func openChest():
	rng.randomize()

	if GlobalLevelTracking.previousScore > 500:
		var randomNum = rng.randi_range(5,8)
		getAbilities(randomNum, GlobalLevelTracking.commonAbilities)
	elif GlobalLevelTracking.previousScore > 400:
		var randomNum = rng.randi_range(4,6)
		getAbilities(randomNum, GlobalLevelTracking.commonAbilities)
	elif GlobalLevelTracking.previousScore > 300:
		var randomNum = rng.randi_range(3,5)
		getAbilities(randomNum, GlobalLevelTracking.commonAbilities)
	elif GlobalLevelTracking.previousScore > 200:
		var randomNum = rng.randi_range(2,4)
		getAbilities(randomNum, GlobalLevelTracking.commonAbilities)
	else:
		var randomNum = rng.randi_range(2,3)
		getAbilities(randomNum, GlobalLevelTracking.commonAbilities)

func getAbilities(count, abilityPool):
	for i in range(count):
		var randomIndex = rng.randi_range(0, abilityPool.size() - 1)
		var newAbility = abilityPool[randomIndex]
		nextAbilities.append(newAbility)

	GlobalLevelTracking.levelAbilities[GlobalLevelTracking.justPlayedLevel + 1] = nextAbilities
	# Output the selected abilities (for debugging or display)
	print("Abilities received: ", nextAbilities)
	displayAbilities()
func displayAbilities():
	$portal.visible = true
	_portalMachine.start("open")
	
	var open_animation_length = $AnimationTree2.get_animation("open").length
	await get_tree().create_timer(open_animation_length).timeout
	
	var screen_width = get_viewport_rect().size.x  # Get the screen width
	var start_position = Vector2(screen_width / 2, 300)  # Center point
	var ability_count = nextAbilities.size()

	# Calculate even spacing based on the number of abilities
	var max_spacing = 150  # Maximum space between sprites
	var min_spacing = 80   # Minimum space to avoid overlap
	var total_width = min(ability_count * max_spacing, screen_width * 0.8)
	var spacing = max(min_spacing, total_width / max(ability_count - 1, 1))

	for i in range(ability_count):
		print("adding ability")
		var ability = nextAbilities[i]
		var abilitySprite = Sprite2D.new()
		var abilityInstance = load(ability).instantiate()

		# Set initial properties for ability sprite
		add_child(abilityInstance)
		abilitySprite.texture = abilityInstance.get_child(0).texture
		abilitySprite.scale = Vector2(0.05, 0.05)

		# Start all abilities from the center point
		abilitySprite.position = start_position
		$CanvasLayer.add_child(abilitySprite)

		# Ensure the tween is created after the node is added to the scene
		var tween = create_tween()

		# Calculate target position for even distribution
		var target_x = (screen_width / 2) - (total_width / 2) + (i * spacing)
		var target_position = Vector2(target_x, 300)

		# Animate the ability to its position
		tween.tween_property(abilitySprite, "position", target_position, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

		# Delay each ability animation slightly for a cascade effect
		await get_tree().create_timer(0.2).timeout
		$CenterContainer/Levels_bttn.visible = true




func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(levels_scene)
