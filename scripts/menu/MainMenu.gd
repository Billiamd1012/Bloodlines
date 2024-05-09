extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://scenes/Room.tscn")

func _on_OptionsButton_pressed() -> void:
	pass # Replace with function body.

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
