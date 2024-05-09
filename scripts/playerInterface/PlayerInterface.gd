extends Node2D
class_name PlayerInterface

onready var node_building_manager: Spatial = $BuildingManager

var current_building: Spatial
var building_placer_can_place:bool = false
var building_placer_location:Vector3 = Vector3.ZERO

# 0 == unit_input_mode; 1 == building_input_mode
var interface_input_mode:int = 0

func set_interface_input_mode(new_value) -> void:
	interface_input_mode = new_value
	
	if interface_input_mode == 1:
		node_building_manager.enable_area()
	elif interface_input_mode == 0:
		node_building_manager.hide()
		node_building_manager.disable_area()

func _physics_process(delta:float) -> void:
	if interface_input_mode == 1:
		var mouse_pos:Vector2 = get_global_mouse_position()
		var camera:Camera = get_viewport().get_camera()
		
		var ray_from: Vector3 = camera.project_ray_origin(mouse_pos)
		var ray_to: Vector3 = ray_from + camera.project_ray_normal(mouse_pos) * 1000.0

		var space_state: PhysicsDirectSpaceState = camera.get_world().direct_space_state
		var result = space_state.intersect_ray(ray_from, ray_to, [], 0b10)
		
		if result:
			if node_building_manager.transform.origin != result.position:
				node_building_manager.transform.origin = result.position
				node_building_manager.show()
				if node_building_manager.placement_check():
					building_placer_location = result.position
					building_placer_can_place = true
				else:
					building_placer_can_place = false
					building_placer_location = Vector3.ZERO
	else:
		building_placer_can_place = false
		building_placer_location = Vector3.ZERO
				

func _input(event:InputEvent) -> void:
	if Input.is_action_just_released("mouseLeft"):
		var shift:bool = Input.is_action_pressed("shift")
		
		if interface_input_mode == 1:
			if building_placer_can_place and building_placer_location != Vector3.ZERO:
				var building_node:Spatial = current_building.duplicate()
				get_parent().add_child(building_node)
				building_node.transform.origin = building_placer_location
				
				if !shift: #reset back to unit mode
					interface_input_mode = 0

func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			if interface_input_mode == 0: #Exits building mode if any input
				interface_input_mode = 0
				get_viewport().set_input_as_handled()
