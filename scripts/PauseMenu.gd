extends Control

var hud: Control  # Variable to store the player interface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud = get_node("/root/Room/PlayerInterface/HUD") as Control  # Get the player interface
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		if get_tree().current_scene.filename == "res://scenes/Room.tscn" and not self.visible:
			get_tree().paused = true
			hud.hide()
			self.show()

func _on_ResumeButton_pressed() -> void:
	hud.show()  # Show the player interface
	self.hide()  # Hide the pause menu
	
	get_tree().paused = false  # Resume the game

func _on_OptionsButton_pressed() -> void:
	pass  # Do nothing

func _on_MenuButton_pressed() -> void:
	get_tree().change_scene("res://scenes/menu/MainMenu.tscn")  # Load the main menu scene
