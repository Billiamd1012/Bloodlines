extends Button

@onready var player_interface: PlayerInterface = get_node("/root/Room/PlayerInterface")

func _on_PlaceBuildingButton_pressed() -> void:
	if self.text == "Enter building mode":
		player_interface.interface_input_mode = 1
		self.text = "Exit building mode"

	else:
		player_interface.interface_input_mode = 0
		self.text = "Enter building mode"
