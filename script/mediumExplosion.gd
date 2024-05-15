extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("explosionAnimation")
	pass # Replace with function body.





func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explosionAnimation":
		queue_free()
	pass # Replace with function body.
