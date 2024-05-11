extends CharacterBody3D

enum Task{
	GettingResources,
	Searching,
	Delivering,
	Walking
}

var CurrentTask = Task.Searching
var Hut
var HeldResourceAmount := 0
@export var WalkSpeed : int = 6
@export var ResourceGenerationAmount := 0
@onready var navagent : NavigationAgent3D = $NavigationAgent3D
var runOnce := true
@export var ResourceNameToGet : String# (String, "stone", "tree", "iron")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match CurrentTask:
		Task.GettingResources:
			if runOnce:
				runOnce = false
				await get_tree().create_timer(2.0).timeout
				runOnce = true
				HeldResourceAmount = ResourceGenerationAmount
				CurrentTask = Task.Delivering
		Task.Searching:
			var resources = get_tree().get_nodes_in_group(ResourceNameToGet)
			var nearestResourceObject = resources[0]
			for i in resources:
				if i.position.distance_to(position) < nearestResourceObject.position.distance_to(position):
					nearestResourceObject = i
			navagent.set_target_position(nearestResourceObject.global_position)
			CurrentTask = Task.Walking
		Task.Delivering: 
			var stockpiles = get_tree().get_nodes_in_group("Stockpile")
			if stockpiles.size() > 0:
				if stockpiles[0].spawned:
					var nearestStockpileObject = stockpiles[0]
					for i in stockpiles:
						if i.spawned:
							if i.position.distance_to(position) < nearestStockpileObject.position.distance_to(position):
								nearestStockpileObject = i
					navagent.set_target_position(nearestStockpileObject.get_node("SpawnPoint").global_position)
					CurrentTask = Task.Walking
				else:
					navagent.set_target_position(Hut.global_position)
					CurrentTask = Task.Walking
			else:
				navagent.set_target_position(Hut.global_position)
				CurrentTask = Task.Walking
		Task.Walking:
			if navagent.is_navigation_finished():
				if HeldResourceAmount == 0:
					CurrentTask = Task.GettingResources
				else:
					match ResourceNameToGet:
						"iron":
							GameManager.Iron += HeldResourceAmount
						"tree":
							GameManager.Wood += HeldResourceAmount
						"stone":
							GameManager.Stone += HeldResourceAmount
					HeldResourceAmount = 0
					CurrentTask = Task.Searching
				return
				
			var targetpos = navagent.get_next_path_position()
			var direction = global_position.direction_to(targetpos)
			var move_velocity = direction * WalkSpeed
			set_velocity(move_velocity)
			move_and_slide()
			
	$Label3D.text = str(CurrentTask)
