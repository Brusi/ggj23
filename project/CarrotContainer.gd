tool

extends Node2D

func _ready():
	if get_child_count() <= 1:
		return
	
	var count: = get_child_count()
	var min_x:float = get_child(0).position.x
	var max_x:float = get_child(count-1).position.x
	var diff: = 46.34
	
	for i in range(get_child_count()):
		get_child(i).position.x = min_x + i * diff
