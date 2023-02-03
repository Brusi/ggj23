extends Node2D

class_name Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var carrots := []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		
	print(Engine.get_frames_per_second())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
