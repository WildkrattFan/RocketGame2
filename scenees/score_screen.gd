extends Node2D

var textNum = 0

func _ready() -> void:
	while textNum < GlobalLevelTracking.previousScore:
		textNum += 1
		$CanvasLayer/RichTextLabel.text = str(textNum)
		await get_tree().create_timer(0.001).timeout
