extends Node2D

var mine_scene = preload("res://scenees/player and weapons/mine.tscn")

func use(delta,player):
	var mineI = mine_scene.instantiate()
	var spawn_position = player.position + Vector2(0, 105).rotated(player.rotation)
	mineI.position = spawn_position
	mineI.rotation = player.rotation
	mineI.shooter = player
	player.get_parent().add_child(mineI)
	pass
	
	
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
