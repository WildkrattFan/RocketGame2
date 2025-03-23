extends Node2D

var direction = Vector2(2,2)
var speed = 1
var blackhole = preload("res://scenees/blackHole.tscn")


func _ready() -> void:
	$Timer.start()
	
func _process(delta: float) -> void:
	rotation += .1
	
	if direction:
		position += speed


func explode():
	print("blackhole bomb exploding!!!")
	var blackholeI = blackhole.instantiate()
	blackholeI.global_position = global_position
	blackholeI.min_scale = 1
	blackholeI.max_scale = 1
	blackholeI.min_orbit_radius = 1
	blackholeI.max_orbit_radius = 1
	get_parent().add_child(blackholeI)
	blackholeI.global_position = global_position
	queue_free()
	
	pass


func _on_timer_timeout() -> void:
	explode()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("blackHole")):
		explode()
	if(area.is_in_group("missile")):
		explode()
	if(area.is_in_group("emp")):
		explode()
	if(area.is_in_group("obstical")):
		explode()
	if(area.is_in_group("enemy")):
		explode()
