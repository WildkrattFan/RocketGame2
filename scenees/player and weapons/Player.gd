extends Node2D

signal mainPlayerExploded






func _on_player_exploded():
	mainPlayerExploded.emit()
