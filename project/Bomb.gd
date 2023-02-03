extends Node2D

signal exploded

var t: = 1.0
export var duration_sec = 20

onready var rabbit: Rabbit = get_parent().get_node("RightMask/Rabbit")

var alive: = true
var falling: = false
var speed: = 0.0

var decoy:Node2D

var screenshake: = 0.0

func _ready():
	init_curve()
	get_node("/root/Game/LeftMask").clone_obj(self)

func init_curve():
	$Path2D.curve.clear_points()
	for point in $PathPoints.get_children():
		($Path2D.curve as Curve2D).add_point(point.position)
		
func _process(delta):
	$Sprite.visible = falling and alive
	$Decoy.visible = not falling and alive
	
	if falling:
		return

	t -= delta / duration_sec
	t = max(t, 0)
	($Path2D/PathFollow2D as PathFollow2D).unit_offset = t
	if t <= 0:
		explode()

func _physics_process(delta):
	if not alive:
		queue_free()
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
	if not alive:
		return
	alive = false
	
	var explosion: = preload("res://Explosion.tscn").instance()
	explosion.global_position = global_position
	
	var explosion2: = preload("res://Explosion.tscn").instance()
	explosion2.global_position = decoy.global_position
	
	get_parent().add_child(explosion)
	get_parent().add_child(explosion2)
	
	$White.visible = true
	$Sprite.visible = false
	
	decoy.get_node("White").visible = true
	decoy.get_node("Sprite").visible = false
	
func copy_state_to(dst):
	(dst.get_node("Path2D/PathFollow2D") as PathFollow2D).unit_offset = t
	
	var spark: = preload("res://Spark.tscn").instance()
	spark.position = dst.get_node("Path2D/PathFollow2D").position
	dst.add_child(spark)

