extends Control

export (Array, NodePath) var parent_elements_to_clone
export (NodePath) var other_mask

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	for child in get_children():
		child.queue_free()
	
	var original_position = Vector2(rect_position.x, rect_position.y)
	
	rect_position = get_node(other_mask).rect_position
	
	for element in parent_elements_to_clone:
		for obj in get_node(element).get_children():
			var new_obj = obj.duplicate()
			new_obj.script = null
			add_child(new_obj)
	
	rect_position = original_position
	
