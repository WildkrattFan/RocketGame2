extends Node2D

var bomb = preload("res://scenees/player and weapons/blackhole_bomb.tscn")
var rarity = "legendary"

func use(delta, player):
	var bombI = bomb.instantiate()
	bombI.speed = player.velocity
	bombI.position = player.position + Vector2(0,85).rotated(player.rotation)
	bombI.rotation = player.rotation
	player.get_parent().add_child(bombI)
	
	
	
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
