extends Sprite


onready var rabbit: Rabbit = get_parent().get_node("RightMask/Rabbit")
var current_fade_out_time := 0.0
export var total_fade_out_time := 0.4

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rabbit.is_dead_or_about_to():
		if current_fade_out_time < total_fade_out_time:
			modulate.a = max(0, cos(PI * current_fade_out_time / total_fade_out_time))
			current_fade_out_time += delta
		else:
			modulate.a = 0
