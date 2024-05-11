extends Node3D

var sens: float = 1  # Sensitivity of the camera movement
var move: Vector3 = Vector3(0, 0, 0)  # Class variable to store the movement

# Lock mouse inside the window
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	


func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var screen_size: Vector2 = get_viewport().get_visible_rect().size

	if mouse_pos.x < screen_size.x * 0.05:
		move.x = -1
	elif mouse_pos.x > screen_size.x * 0.95:
		move.x = 1
	elif mouse_pos.y < screen_size.y * 0.05:
		move.z = -1
	elif mouse_pos.y > screen_size.y * 0.95:
		move.z = 1
	else:
		move = Vector3(0, 0, 0)  # Stop the movement when the mouse is not near the edges

	if Input.is_action_pressed("moveLeft"):
		move.x -= 1
	if Input.is_action_pressed("moveRight"):
		move.x += 1
	if Input.is_action_pressed("moveBack"):
		move.z += 1
	if Input.is_action_pressed("moveForward"):
		move.z -= 1
	
	# Zoom in and out
	
	if Input.is_action_just_released("MouseWheelUp"):
		if $Camera3D.global_position.distance_to(global_position) > 20:
			$Camera3D.global_position -= $Camera3D.global_transform.basis.z * 2

	if Input.is_action_just_released("MouseWheelDown"):
		if $Camera3D.global_position.distance_to(global_position) < 50:
			$Camera3D.global_position += $Camera3D.global_transform.basis.z * 2
	
	move = move.normalized() * sens  # Normalize the move vector before applying the speed
	
	self.global_translate(move)
	move = Vector3(0, 0, 0)  # Reset the movement vector for the next frame
	
