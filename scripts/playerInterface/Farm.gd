extends Button

@onready var building: Node3D = $BlueBox
@onready var player_interface: PlayerInterface = get_node("/root/Room/PlayerInterface")


# On press 
func _on_Farm_pressed():
	player_interface.interface_input_mode = 1
	player_interface.current_building = building

