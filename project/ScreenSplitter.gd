extends Control

var cloned_objects = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clone_obj(obj):
	var new_obj = obj.duplicate()
	new_obj.script = null
	add_child(new_obj)
	
	_copy_state(obj, new_obj)
	cloned_objects.append([new_obj, obj])

func _copy_state(src, dst):
	dst.global_position = src.global_position - Vector2(985, -63)
	dst.rotation = src.rotation
	dst.modulate = src.modulate
	dst.scale = src.scale
	
	src.copy_state_to(dst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var keep_objects = []
	for cloned_object in cloned_objects:
		if cloned_object[1].alive:
			keep_objects.append(cloned_object)
			_copy_state(cloned_object[1], cloned_object[0])
		else:
			cloned_object[0].queue_free()
	
	cloned_objects = keep_objects
	
