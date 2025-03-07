extends Node2D

var activated = false

var user = null;

func _process(delta: float) -> void:
	print("aww")
	if user:
		print("YAY")
		user.velocity += user.direction * user.speed * 10 * delta

	


func use(delta, player):
	player.position += player.direction * player.speed * 1000 * delta
	user = player
	activated = true

			#$Camera2D.position_smoothing_speed = 15
			#max_velocity = 100
		#elif max_velocity > normal_max_velocity:
			#max_velocity *= .97
			#$Camera2D.position_smoothing_speed = 4
