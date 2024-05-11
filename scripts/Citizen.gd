extends CharacterBody3D

enum Task{
	Walking,
	Sitting
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var FirePitPos : Marker3D
@onready var navagent: NavigationAgent3D = $NavigationAgent3D
var currentTask = Task.Walking
@export var WalkSpeed := 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SpawnObjectSetup():
	navagent.set_target_position(FirePitPos.global_position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match currentTask:
		Task.Sitting:
			pass
		Task.Walking:
			if navagent.is_navigation_finished():
				currentTask = Task.Sitting
				return
				
			var targetpos = navagent.get_next_path_position()
			var direction = global_position.direction_to(targetpos)
			var move_velocity = direction * WalkSpeed
			set_velocity(move_velocity)
			move_and_slide()
	pass
	
func _on_velocity_computed(move_velocity):
	#print(" Citizen: " + str(velocity))
	set_velocity(move_velocity)
	move_and_slide()
	pass
