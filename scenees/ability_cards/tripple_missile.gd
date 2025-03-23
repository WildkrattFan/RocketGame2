extends Node2D

var player = null;
var missile = preload("res://scenees/player and weapons/heatMissile.tscn")
var rarity = "common"
@export var shoot_speed = 1500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func use(delta,player):

	
	var projectile_rotations = [-5,0,5]
	
	for i in range(len(projectile_rotations)):
		var projectile0 = missile.instantiate()
		projectile0.position = player.position + Vector2(0, -85).rotated(player.rotation + projectile_rotations[i])
		projectile0.rotation = player.rotation + projectile_rotations[i]
		var direction0 = Vector2(0, -1).rotated(player.rotation + projectile_rotations[i])
		projectile0.set_velocity(direction0 * shoot_speed + player.velocity)
		projectile0.setPlayer(player)
		player.get_parent().add_child(projectile0)
	
	
	pass
	
#func shoot():
	#var random_variance = 0
	## Calculate the spawn position of the projectile
	#if current_ammo == "Machine Gun":
		#random_variance = randf_range(-10, 10)
	#var spawn_position = position + Vector2(random_variance, -85).rotated(rotation)
#
	#
	## Instantiate the projectile scene
	#var new_projectile = projectile_scene.instantiate()
	#
	## Set the projectile's position and rotation
	#new_projectile.position = spawn_position
	#new_projectile.rotation = rotation
	#
	## Set the projectile's velocity
	#var shootDirection = Vector2(0, -1).rotated(rotation)
	#new_projectile.set_velocity(shootDirection * shoot_speed + self.velocity)
	#
	## Add the projectile to the scene
	#new_projectile.setPlayer(self)
	#get_parent().add_child(new_projectile)
