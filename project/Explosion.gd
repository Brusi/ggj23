extends Node2D

var screenshake: = 0.0

func _ready():
	get_tree().paused = true
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().paused = false
	
	screenshake = 30.0
	for i in range(150):
		var circle: = preload("res://Circle.tscn").instance()
		circle.position += Vector2(rand_range(-20,20),rand_range(-40,40))
		add_child(circle)
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	# Just in case.
	for game in get_tree().get_nodes_in_group("game"):
		game.position = Vector2.ZERO

	queue_free()

func _process(delta):
	for game in get_tree().get_nodes_in_group("game"):
		if screenshake > 0.0:
			game.position = Vector2.RIGHT.rotated(rand_range(-PI,PI)) * rand_range(0, screenshake)
			screenshake *= 0.9
		else:
			game.position = Vector2.ZERO
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
