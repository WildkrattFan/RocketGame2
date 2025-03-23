extends Area2D


@export var dialouge_resource: DialogueResource
@export var dialouge_start: String = "start"
@export var sprite: Texture2D

const Balloon = preload("res://dialogue/balloon.tscn")
const SpriteBalloon = preload("res://dialogue/sprite_balloon.tscn")
var balloon: Node


func action() -> void:
	if !sprite:
		balloon = Balloon.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialouge_resource, dialouge_start)
	else:
		balloon = SpriteBalloon.instantiate()
		balloon.Sprite = sprite
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialouge_resource, dialouge_start)
	
func close() -> void:
	if balloon:
		balloon.queue_free()
