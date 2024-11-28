extends Node

enum State{
	Play,
	Building,
	Destroying
}

var CurrentState = State.Play
var TimeBetweenResourceUpdates : float = 6.0

var Wood := 500
var Stone := 50
var Gold := 100
var Iron := 0
var Food := 1000

var Population : int = 0
var MaxPopulation : int = 4
var AlvPopulation : int = 0
var Citizen : PackedScene
var Happiness := 1
var spawnReady := true
var firePitSpaces : Array
var occupiedFirePitSpaces : Array
var foodBool = true
var TaxRate := 2
# Called when the node enters the scene tree for the first time.
func _ready():
	Citizen = ResourceLoader.load("res://Assets/Citizen.tscn")
	firePitSpaces = get_tree().get_nodes_in_group("CitizenSpawnPoint")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	spawnReady = false
	await get_tree().create_timer(3.0).timeout
	spawnReady = true
	if Population < MaxPopulation && spawnReady && Happiness > 0 && firePitSpaces.size() > 0:
		SpawnPop()
	elif spawnReady && Happiness < 0 && AlvPopulation > 0:
		RemoveCitizen(1)
	
	AdjustResources()
	pass

func RemoveCitizen(Cost : int):
	for i in range(0, Cost, 1):
		firePitSpaces.append(occupiedFirePitSpaces[0])
		var temp : Node = occupiedFirePitSpaces[0]
		delete_children(temp)
		occupiedFirePitSpaces.remove_at(0)
		AlvPopulation -= 1
		Population -= 1

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func SpawnPop():
	var citizen = Citizen.instance()
	firePitSpaces[0].add_child(citizen)
	citizen.FirePitPos = firePitSpaces[0]
	citizen.SpawnObjectSetup()
	occupiedFirePitSpaces.append(firePitSpaces.pop_front())
	Population += 1
	AlvPopulation += 1

# Adjust the resources every TimeBetweenResourceUpdates seconds
func AdjustResources():
	foodBool = false
	await get_tree().create_timer(TimeBetweenResourceUpdates).timeout
	Food -= Population
	if Food < 0:
		Food = 0
	foodBool = true

	Gold += round(Population * TaxRate)

	var happinessValue = 1
	if Food > 0:
		happinessValue += 1
	else:
		happinessValue -= 10
	
	if TaxRate > 0:
		happinessValue -= round(float(TaxRate) / 2)
	if TaxRate < 0:
		happinessValue -= round(float(TaxRate) / 2)
	
	Happiness += happinessValue
	if Happiness >= 2:
		Happiness = 2
	elif Happiness <= -2:
		Happiness = -2
