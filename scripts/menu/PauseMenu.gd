extends Control

var interface: Control  # Variable to store the player interface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface = get_node("/root/Room/Interface") as Control  # Get the player interface
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if get_tree().current_scene.name == "Room" and not self.visible:
			get_tree().paused = true
			interface.hide()
			self.show()

func _on_ResumeButton_pressed() -> void:
	interface.show()  # Show the player interface
	self.hide()  # Hide the pause menu
	
	get_tree().paused = false  # Resume the game

func _on_OptionsButton_pressed() -> void:
	pass  # Do nothing

func _on_MenuButton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")  # Load the main menu scene
