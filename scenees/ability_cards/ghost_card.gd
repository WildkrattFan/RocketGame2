extends Node2D

var hitBox = null
var player = null
var visibilityArea = null

func use(delta, player):
	self.player = player
	player.switchShoot(false)
	hitBox = player.find_child("playerHitBox")
	visibilityArea = player.find_child("visibility area")
	if hitBox:
		hitBox.monitoring = false
		hitBox.monitorable = false
	if visibilityArea:
		visibilityArea.monitoring = false
		visibilityArea.monitorable = false
	player.modulate.a = 0.5
	$Timer.start()

func _process(delta: float) -> void:
	# Make the player blink when less than half time is left
	if player:
		if $Timer.time_left < ($Timer.wait_time / 3.0):
			# Toggle transparency using time
			player.modulate.a = 0.5 + 0.5 * sin($Timer.time_left * 10)

func _on_timer_timeout() -> void:
	player.switchShoot(true)
	if hitBox:
		hitBox.monitoring = true
		hitBox.monitorable = true
	if visibilityArea:
		visibilityArea.monitoring = true
		visibilityArea.monitorable = true
	player.modulate.a = 1  # Restore visibility
	queue_free()
