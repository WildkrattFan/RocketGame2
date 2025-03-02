extends Node2D

var player = null;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shield_Bubble_Sprite.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(player):
		global_position = player.global_position

	
func activate_sheild(player):
	print("getting picked up!")
	$Shield_Bubble_Sprite.visible = true
	$Pickup_sprite.visible = false
	$pickup_area/CollisionShape2D.disabled = true
	$bubble_area/CollisionShape2D.disabled = false
	$Ability_timer.start()
	


func _on_pickup_area_area_entered(area: Area2D) -> void:
	if(area.is_in_group("player") and area.name == "playerHitBox"):
		player = area
		activate_sheild(player)
		#activate the shield and follow the player while starting the timer
	else:
		pass
		#do nothing


func _on_ability_timer_timeout() -> void:
	queue_free()


func _on_bubble_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
