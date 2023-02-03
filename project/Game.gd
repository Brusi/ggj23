extends Node2D

class_name Game

export var splash: = false

var carrots := []

var ended: = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		
	print(Engine.get_frames_per_second())
	
func end():
	ended = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
