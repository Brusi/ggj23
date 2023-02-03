extends Sprite

const offset_from_carrot: = Vector2(-940, -50)

export var carrot_path:NodePath
onready var carrot = get_node(carrot_path)

func _ready():
	global_position = carrot.global_position - offset_from_carrot
	
func _process(delta):
	offset = carrot.offset
