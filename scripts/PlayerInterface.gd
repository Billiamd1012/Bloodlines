# Interface between the player and the game world by updating the cursors relative position on the map every frame

extends Node
class_name PlayerInterface

# Script variables
var interface_input_mode: int = 0
var nodes_loaded: bool = false  # Flag to check if nodes are loaded
var cursor_position_on_map: Dictionary = {}  # Store the cursor position on the map

# UI
onready var hud: Control = get_node("HUD") as Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	nodes_loaded = true  # Set the flag to true when all nodes are loaded

func _physics_process(_delta: float) -> void:
	if nodes_loaded: 
		var mouse_pos: Vector2 = hud.get_global_mouse_position()
		var camera: Camera = get_node("Camera/Camera") as Camera
		var world: World = camera.get_world()

		var from: Vector3 = camera.project_ray_origin(mouse_pos)
		var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * 1000

		var space_state: PhysicsDirectSpaceState = world.direct_space_state
		cursor_position_on_map = space_state.intersect_ray(from, to, [], 1)  # Set the collision mask to 1 to ignore layer 2
