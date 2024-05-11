extends Node3D


var WoodCuttersHut: PackedScene = ResourceLoader.load("res://assets/buildings/WoodCutters.tscn")
var StoneMasons: PackedScene = ResourceLoader.load("res://assets/buildings/StoneMasons.tscn")
var CastleKeep: PackedScene = ResourceLoader.load("res://assets/buildings/CastleKeep.tscn")
var Granery: PackedScene = ResourceLoader.load("res://assets/buildings/Granery.tscn")
var House: PackedScene = ResourceLoader.load("res://assets/buildings/House.tscn")
var Orchard: PackedScene = ResourceLoader.load("res://assets/buildings/Orchard.tscn")
var Stockpile: PackedScene = ResourceLoader.load("res://assets/buildings/Stockpile.tscn")
var Wall: PackedScene = ResourceLoader.load("res://assets/buildings/wallNarrow.tscn")
var WallCorner: PackedScene = ResourceLoader.load("res://assets/buildings/wallNarrowCorner.tscn")
var WallGate: PackedScene = ResourceLoader.load("res://assets/buildings/wallNarrowGate.tscn")

var CurrentSpawnable : StaticBody3D
var AbleToBuild: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.CurrentState == GameManager.State.Building:
		pass


func _process(_delta):
	if GameManager.CurrentState == GameManager.State.Building:
		# Raycast to determine where the cursor is on the ground
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
		var cursorPos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
		
		# Set current building preview to cursor position
		CurrentSpawnable.position = Vector3(round(cursorPos.x), cursorPos.y, round(cursorPos.z))
		CurrentSpawnable.ActiveBuildableObject = true
		
		if AbleToBuild && canAfford(CurrentSpawnable):
			if Input.is_action_just_pressed("MouseLeft"):
				PlaceBuilding()
				
		if Input.is_action_just_released("MouseRight"):
			ExitBuildingMode()
		
	pass

func chargeObject(obj):
	GameManager.Wood -= obj.WoodCost
	GameManager.Iron -= obj.IronCost
	GameManager.Stone -= obj.StoneCost
	GameManager.Gold -= obj.GoldCost

func canAfford(obj) -> bool:
	if GameManager.Wood - obj.WoodCost < 0:
		return false
	if GameManager.Stone - obj.StoneCost < 0:
		return false
	if GameManager.Gold - obj.GoldCost < 0:
		return false
	if GameManager.Iron - obj.IronCost < 0:
		return false
	return true

func SpawnWoodCutter():
	SetCurrentSpawnable(WoodCuttersHut)

func SpawnStoneCutter():
	SetCurrentSpawnable(StoneMasons)
	
func SpawnStockpile():
	SetCurrentSpawnable(Stockpile)
	
func SpawnGranery():
	SetCurrentSpawnable(Granery)
	
func SpawnOrchard():
	SetCurrentSpawnable(Orchard)
	
func SpawnHouse():
	SetCurrentSpawnable(House)
	
func SpawnWallNarrow():
	SetCurrentSpawnable(Wall)
		

func SetCurrentSpawnable(building):
	if CurrentSpawnable != null:
		CurrentSpawnable.queue_free()
	CurrentSpawnable = building.instantiate()
	CurrentSpawnable.SetDisabled(true)
	get_tree().root.add_child(CurrentSpawnable)
	GameManager.CurrentState = GameManager.State.Building


func PlaceBuilding():
	var building := CurrentSpawnable.duplicate()
	var navMesh = get_tree().get_nodes_in_group("NavMesh")[0]
	navMesh.add_child(building)
	building.ActiveBuildableObject = false
	building.runSpawn()
	building.spawned = true
	chargeObject(building)
	building.SetDisabled(false)
	building.position = CurrentSpawnable.position
	navMesh.bake_navigation_mesh(true)

func ExitBuildingMode():
	CurrentSpawnable.queue_free()
	CurrentSpawnable = null
	GameManager.CurrentState = GameManager.State.Play
