extends Sprite

export var amplitude: = 40.0

onready var duration: = 60 * rand_range(0.9, 1.1)
onready var t:float = rand_range(0, duration)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	t += delta
	if t >= duration:
		t -= duration
	
	offset.x = amplitude * sin(t/duration * 2 * PI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
