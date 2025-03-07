extends Node2D

var activated = false

var user = null;

func _process(delta: float) -> void:

	if user:

		user.velocity += user.direction * user.speed * 10 * delta

	


func use(delta, player):
	player.position += player.direction * player.speed * 1000 * delta
	user = player
	activated = true
	queue_free()
