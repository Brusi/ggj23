extends Node2D

var carrot_action_margin = 10
onready var rabbit = get_parent().get_parent().get_node("Rabbit")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("rabbit_down"):
		if self._is_rabbit_in_carrot_range():
			
			#Todo 
			# ...
			
			self.visible = false

func _is_rabbit_in_carrot_range():
	return rabbit.position.x <= self.position.x + carrot_action_margin and rabbit.position.x >= self.position.x - carrot_action_margin
