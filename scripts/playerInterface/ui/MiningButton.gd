extends Button

# On click set visibility of all grandchildren of the parent node to false and then set the visibility of the children to true
func _on_MiningButton_pressed():
	for child in get_parent().get_children():
		for grandchild in child.get_children():
			grandchild.visible = false
	for child in get_children():
		child.visible = true
