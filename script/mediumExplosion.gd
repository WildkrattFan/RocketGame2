extends Node2D

var shotBy


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("explosionAnimation")
	$AudioStreamPlayer2D.play()
	$CPUParticles2D.emitting = true





func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explosionAnimation":
		visible = false
	pass

func setPlayer(player):
	shotBy = player


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
