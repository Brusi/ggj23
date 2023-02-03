extends Node2D

signal exploded

var t: = 1.0
export var duration_sec = 20

onready var rabbit: Rabbit = get_parent().get_node("RightMask/Rabbit")

var alive: = true
var falling: = false
var speed: = 0.0

var intact: = true
var screenshake: = 0.0

func _ready():
	init_curve()
	get_node("/root/Game/LeftMask").clone_obj(self)

func init_curve():
	$Path2D.curve.clear_points()
	for point in $PathPoints.get_children():
		($Path2D.curve as Curve2D).add_point(point.position)
		
func _process(delta):
	if not intact:
		for game in get_tree().get_nodes_in_group("game"):
			if screenshake > 0.0:
				game.position = Vector2.RIGHT.rotated(rand_range(-PI,PI)) * rand_range(0, screenshake)
				screenshake *= 0.9
			else:
				game.position = Vector2.ZERO
		return
		
	$Sprite.visible = falling and intact
	$Decoy.visible = not falling and intact

	t -= delta / duration_sec
	t = max(t, 0)
	($Path2D/PathFollow2D as PathFollow2D).unit_offset = t
	if t <= 0:
		explode()


func _physics_process(delta):
	if not intact:
		return
		
	if falling:
		if position.y + 21 < rabbit.position.y + rabbit.shape.extents.y:
			speed += 600 * delta
			position.y += speed * delta
		else:
			rabbit.die_by_bomb()
			explode()

		var spark: = preload("res://Spark.tscn").instance()
		spark.position = $Path2D/PathFollow2D.position
		add_child(spark)

func explode():
	if not intact:
		return
	intact = false
	$White.visible = true
	$Sprite.visible = false
	$Decoy.visible = false
	$Path2D.queue_free()
		
	get_tree().paused = true
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().paused = false
	
	scale.x = 1.0
	scale.y = 1.0
	
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
	alive = false
	queue_free()
	
func copy_state_to(dst):
	(dst.get_node("Path2D/PathFollow2D") as PathFollow2D).unit_offset = t
	
	var spark: = preload("res://Spark.tscn").instance()
	spark.position = dst.get_node("Path2D/PathFollow2D").position
	dst.add_child(spark)

