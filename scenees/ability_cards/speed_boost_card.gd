extends Node2D

var activated = false

var user = null;
var rarity = "rare"


func use(delta, player):
	$AudioStreamPlayer2D.play()
	player.position += player.direction * player.speed * 1000 * delta
	user = player
	activated = true
	if player.has_method("shake_camera"):
		player.shake_camera(100,0.01)
	await $AudioStreamPlayer2D.finished
	queue_free()
	
