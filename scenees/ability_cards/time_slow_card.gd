extends Node2D

var player = null
var original_time_scale = 1.0  # Store the normal time scale
var colorRect

func use(delta, player):
	self.player = player
	slow_time()
	
func slow_time():
	original_time_scale = Engine.time_scale  # Save current time scale
	Engine.time_scale = 0.3  # Slow down time (adjust as needed)
	$Timer.start()  # Start timer to restore normal speed

func _on_timer_timeout():

	Engine.time_scale = original_time_scale  # Restore normal speed
