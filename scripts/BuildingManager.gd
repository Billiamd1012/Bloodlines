extends Node3D


@onready var unit_data: Dictionary = {}

@onready var area: Area3D = $Area3D
@onready var area_colshape: CollisionShape3D = $Area3D/CollisionShape3D
@onready var model: MeshInstance3D = $BuildingPreview

func enable_area() -> void:area_colshape.disabled = false
func disable_area() -> void:area_colshape.disabled = true

func placement_check() -> bool:
	#model red by default
	
#	if area.has_overlapping_bodies():
#		print("Building is overlapping")
#		return false
	
	var area_collision_shape:BoxShape3D = area_colshape.get_shape()
	var area_size: Vector3 = area_collision_shape.extents * 0.5
	var points_to_check:Array = [
		area_collision_shape.global_transform.origin + Vector3(area_size.x, -area_size.y, area_size.z),
		area_collision_shape.global_transform.origin + Vector3(area_size.x, -area_size.y, -area_size.z),
		area_collision_shape.global_transform.origin + Vector3(-area_size.x, -area_size.y, -area_size.z),
		area_collision_shape.global_transform.origin + Vector3(-area_size.x, -area_size.y, area_size.z),]
		
	var y_distances:Array = [] # Save raycasted y height distances.
	
	var i:int = 0
	for point in points_to_check:
		
		var ray_from:Vector3 = points_to_check[i]
		var ray_to:Vector3 = ray_from + Vector3(0,-20.0,0)
		var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var ray_parameters: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
		ray_parameters.from = ray_from
		ray_parameters.to = ray_to
		var result = space_state.intersect_ray(ray_parameters)
		
		if result:
			var y_distance:float = ray_from.y - result.position.y
			y_distances.append(y_distance)
		else:
			print("A raycast for the building check failed to hit the ground")
			return false
		i += 1
	
	for y_distance in y_distances:
		if y_distance > 2.0:
			print("Not planar enouch, raycast failed on Y check")
			return false
	
	# Every condition passed, allow placing building.
	print("Everythin is good! You can now place the building.")
	return true
