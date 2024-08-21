extends Node2D

signal mainPlayerExploded
signal mainPointsAdded





func _on_player_exploded():
	mainPlayerExploded.emit()


func _on_player_points_added() -> void:
	mainPointsAdded.emit()
