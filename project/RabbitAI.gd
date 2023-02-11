extends Node

export var enabled: = true

const min_x: = 980
const max_x: = 1920
const width = max_x - min_x

var target_ratio: = 0.0
var target_x = 0.0

func get_diff(this_x:float, other_x:float) -> float:
	var diff:float = other_x - this_x
	while diff > width/2:
		diff -= width
	while diff < -width/2:
		diff += width
	return diff

func trigger_action(action:String, pressed:bool) -> void:
	#print("Triggering(",action,",",pressed,")")
	var e: = InputEventAction.new()
	e.action = action
	e.pressed = pressed
	Input.parse_input_event(e)
	
func recalc_target():
	var possible_targets: = []
	for carrot in get_tree().get_nodes_in_group("carrot"):
		if carrot.alive:
			possible_targets.push_back(carrot.global_position.x)
	for bomb in get_tree().get_nodes_in_group("bomb"):
		possible_targets.push_back(bomb.global_position.x)

	target_x = possible_targets[randi() % possible_targets.size()]
	$Target.global_position.x = target_x

func _ready():
	if not enabled:
		return
	recalc_target()
	pass # Replace with function body.
	
func _physics_process(delta):
	if not enabled:
		return
	var farmer:Node2D = $"../../Farmer"
	var rabbit:Node2D = $".."
	var farmer_diff = get_diff(rabbit.global_position.x, farmer.global_position.x)
	#if abs(farmer_diff) < 100:
		#recalc_target()
		#return
		
	print("target_x=",target_x)
	print("rabbit.x=",rabbit.global_position.x)
	
	var diff: = get_diff(rabbit.global_position.x, target_x)
	
	print(diff)
	if abs(diff) > 10:
		trigger_action("rabbit_right", diff > 0)
		trigger_action("rabbit_left", diff < 0)
		trigger_action("rabbit_down", false)
	else:
		trigger_action("rabbit_right", false)
		trigger_action("rabbit_right", false)
		if abs(farmer_diff) < 240:
			recalc_target()
			trigger_action("rabbit_down", false)
		else:
			if randf() > delta / 3:
				trigger_action("rabbit_down", true)
			else:
				trigger_action("rabbit_down", false)
				recalc_target()
		#recalc_target()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
