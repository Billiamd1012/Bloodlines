extends Camera

var sens = 5
var move = Vector3(0, 0, 0)  # Class variable to store the movement

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var mouse_pos = get_viewport().get_mouse_position()
		var screen_size = get_viewport().get_visible_rect().size

		if mouse_pos.x < screen_size.x * 0.1:
			move.x = -1
		elif mouse_pos.x > screen_size.x * 0.9:
			move.x = 1
		elif mouse_pos.y < screen_size.y * 0.1:
			move.z = -1
		elif mouse_pos.y > screen_size.y * 0.9:
			move.z = 1
		else:
			move = Vector3(0, 0, 0)  # Stop the movement when the mouse is not near the edges
		move.y = 0  # Lock the y position
		move = move.normalized() * sens

func _process(delta):
	var parent_node = self.get_parent()
	if parent_node:
		parent_node.translate(move * delta)  # Apply the movement to the parent node
