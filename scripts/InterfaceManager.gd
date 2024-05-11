extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateResourceValues()

func _on_Area2D_area_entered(_area):
	BuildManager.AbleToBuild = false


func _on_Area2D_area_exited(_area):
	BuildManager.AbleToBuild = true

func updateResourceValues() -> void:
	$ResourcesControl/ResourcesBox/Wood/WoodValue.text = str(GameManager.Wood)
	$ResourcesControl/ResourcesBox/Stone/StoneValue.text = str(GameManager.Stone)
	$ResourcesControl/ResourcesBox/Food/FoodValue.text = str(GameManager.Food)
	$ResourcesControl/ResourcesBox/Iron/IronValue.text = str(GameManager.Iron)
	$ResourcesControl/ResourcesBox/Gold/GoldValue.text = str(GameManager.Gold)


func _on_BuildStockpile_button_down():
	BuildManager.SpawnStockpile()


func _on_BuildOrchard_button_down():
	BuildManager.SpawnOrchard()

func _on_BuildGranary_button_down():
	BuildManager.SpawnGranery()
	


func _on_BuildHouse_button_down():
	BuildManager.SpawnHouse()


func _on_BuildWall_button_down():
	BuildManager.SpawnWallNarrow()


func _on_BuildWoodCutter_button_down():
	BuildManager.SpawnWoodCutter()


func _on_BuildStoneCutter_button_down():
	BuildManager.SpawnStoneCutter()
