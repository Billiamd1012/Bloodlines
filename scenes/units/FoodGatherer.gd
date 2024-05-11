extends CharacterBody3D

enum Task{
	GettingFood,
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

var FoodProducers : Array
var FoodIndex : int

func _ready():
	FoodProducers = Hut.get_node("Resources").get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match CurrentTask:
		Task.GettingFood:
			if runOnce:
				runOnce = false
				await get_tree().create_timer(2.0).timeout
				runOnce = true
				HeldResourceAmount += ResourceGenerationAmount
				CurrentTask = Task.Searching
				
				if FoodIndex >= FoodProducers.size(): 
					CurrentTask = Task.Delivering
			pass
		Task.Searching:
			navagent.set_target_position(FoodProducers[FoodIndex].global_position)
			CurrentTask = Task.Walking
			pass
		Task.Delivering: 
			var granerys = get_tree().get_nodes_in_group("Granery")
			if granerys.size() > 0:
				var nearestGraneryObject = granerys[0]
				for i in granerys:
					if i.spawned:
						if i.position.distance_to(position) < nearestGraneryObject.position.distance_to(position):
							nearestGraneryObject = i
				navagent.set_target_position(nearestGraneryObject.get_node("SpawnPoint").global_position)
				CurrentTask = Task.Walking
			pass
		Task.Walking:
			if navagent.is_navigation_finished():
				if FoodIndex != FoodProducers.size():
					CurrentTask = Task.GettingFood
					FoodIndex += 1
				else:
					GameManager.Food += HeldResourceAmount
					FoodIndex = 0
					HeldResourceAmount = 0
					CurrentTask = Task.Searching
				return
				
			var targetpos = navagent.get_next_path_position()
			var direction = global_position.direction_to(targetpos)
			var move_velocity = direction * WalkSpeed
			set_velocity(move_velocity)
			move_and_slide()
			pass
	$Label3D.text = str(CurrentTask)
	pass
