# Handles the 

extends HBoxContainer

# Player Interface
onready var player_interface: PlayerInterface = get_node("/root/Room/PlayerInterface")

# Current building
var current_building: Building = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and current_building != null:
		_placeBuilding(current_building)
func _placeBuilding(building: Spatial) -> void:
	if building is Building:
		if player_interface.cursor_position_on_map != {}:
			# Add your code here
			var building_instance = building.scene.instance()  # Create an instance of the building scene
			building_instance.global_transform.origin = player_interface.cursor_position_on_map.position  # Set the position of the instance to the specified position
			get_node("/root/Room").add_child(building_instance)  # Add the instance to the scene tree
