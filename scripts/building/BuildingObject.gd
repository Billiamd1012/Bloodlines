extends StaticBody3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var objects : Array
var ActiveBuildableObject : bool

@export var WoodCost : int
@export var StoneCost : int
@export var IronCost : int
@export var GoldCost : int
@export var PopulationCost : int
@export var IncreasePopCap : bool = false
@export var IncreaseCapAmount : int = 5
@export var IsStockpile : bool = false

@export var SpawnActor : bool = true
@export var Actor : PackedScene
var currentActor
var spawned : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area3D.connect("area_entered", Callable(self, "_on_Area_area_entered"))
	$Area3D.connect("area_exited", Callable(self, "_on_Area_area_exited"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func runSpawn():
	if SpawnActor:
		var actor = Actor.instantiate()
		currentActor = actor
		actor.Hut = $SpawnPoint
		get_tree().root.add_child(actor)
		actor.global_position = $SpawnPoint.global_position
	if IncreasePopCap:
		GameManager.MaxPopulation += IncreaseCapAmount
		
func runDespawn():
	if SpawnActor:
		currentActor.queue_free()
	GameManager.Population -= PopulationCost
	if IncreasePopCap:
		GameManager.Population -= IncreaseCapAmount
	queue_free()
	
func _on_Area_area_entered(area):
	if ActiveBuildableObject:
		objects.append(area)
		BuildManager.AbleToBuild = false
		print(objects)
	pass # Replace with function body.


func _on_Area_area_exited(area):
	if ActiveBuildableObject:
		objects.remove_at(objects.find(area))
		print(objects)
		if(objects.size() <= 0):
			BuildManager.AbleToBuild = true
	pass # Replace with function body.

func SetDisabled(disabled : bool):
	$CollisionShape3D.disabled = disabled
