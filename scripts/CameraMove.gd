extends Camera

var sens: float = 8  # Sensitivity of the camera movement
var move: Vector3 = Vector3(0, 0, 0)  # Class variable to store the movement

func _process(delta: float) -> void:
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

	move = move.normalized() * sens  # Normalize the move vector before applying the speed

	var parent_node: Node = self.get_parent()
	if parent_node:
		parent_node.translate(move * delta)  # Apply the movement to the parent node

	move = Vector3(0, 0, 0)  # Reset the movement vector for the next frame
