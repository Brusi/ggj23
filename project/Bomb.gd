extends Node2D

signal exploded

var t: = 1.0
export var duration_sec = 2

var done: = false
var screenshake: = 0.0

func _ready():
	init_curve()

func init_curve():
	for point in $PathPoints.get_children():
		($Path2D.curve as Curve2D).add_point(point.position)
		
func _process(delta):
	if done:
		for game in get_tree().get_nodes_in_group("game"):
			if screenshake > 0.0:
				game.position = Vector2.RIGHT.rotated(rand_range(-PI,PI)) * rand_range(0, screenshake)
				screenshake *= 0.9
			else:
				game.position = Vector2.ZERO
		return

	t -= delta / duration_sec
	t = max(t, 0)
	$Path2D/PathFollow2D.unit_offset = t
	if t <= 0:
		explode()


func _physics_process(delta):
	if done:
		return
	var spark: = preload("res://Spark.tscn").instance()
	spark.position = $Path2D/PathFollow2D.position
	add_child(spark)

func explode():
	if done:
		return
	$White.visible = true
	done = true
	$Sprite.visible = false
	$Path2D.queue_free()
		
	get_tree().paused = true
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().paused = false
	
	screenshake = 30.0
	for i in range(150):
		var circle: = preload("res://Circle.tscn").instance()
		circle.position += Vector2(rand_range(-20,20),rand_range(-40,40))
		add_child(circle)
	
	$White.visible = false
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	# Just in case.
	for game in get_tree().get_nodes_in_group("game"):
		game.position = Vector2.ZERO
	queue_free()
	
