extends Node2D

@export var speed = 400  # Adjust this value as needed
var velocity = Vector2.ZERO
var time_to_explode = 2.0


func _ready():
	$Timer.set_wait_time(time_to_explode)
	$Timer.start()

func _process(delta):
	# Move the projectile based on its velocity
	position += velocity * delta

func set_velocity(new_velocity):
	velocity = new_velocity


func _on_area_2d_area_entered(area):
	explosion()






func explosion():
	print("Explosion!!!")
	queue_free()
	


func _on_timer_timeout():
	explosion()
