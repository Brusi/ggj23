extends Node

const min_x: = 980.0
const max_x: = 1920.0
const rabbit_speed: = 200.0  # Based on rabbit.

@export var notice_interval: = 1.0

@onready var enabled: = Settings.farmer_ai

var started: = false

var target: = 0.0

var last_rabbit_pos:float = lerp(min_x, max_x, 0.5)
var possible_dist: = 400

var next_hit: = randf_range(0, 1.0)

var elapsed_time: float = 0.0
var notice_timer: float = 0.0
var reported_pos: float = 0.0
var reported_time: float = 0.0
var has_new_report: bool = false

func _ready():
	trigger_action("farmer_pitchfork", false)
	trigger_action("farmer_right", false)
	trigger_action("farmer_left", false)
	
	if not enabled:
		return
	update_loop()
	
func update_loop():
	# A few sec delay at start
	await get_tree().create_timer(2.0).timeout
	if not is_instance_valid(self):
		return
	started = true
	while true:
		if not is_instance_valid(self):
			return
		trigger_action("farmer_action_1", true)
		await get_tree().create_timer(0.05).timeout
		trigger_action("farmer_action_1", false)
		await get_tree().create_timer(0.75).timeout

	
func trigger_action(action:String, pressed:bool) -> void:
	#print("Triggering(",action,",",pressed,")")
	var e: = InputEventAction.new()
	e.action = action
	e.pressed = pressed
	Input.parse_input_event(e)
	
func update_target():
	var width:float = max_x - min_x
	#print("possible_dist=",possible_dist)
	target = lerp(last_rabbit_pos - possible_dist, last_rabbit_pos + possible_dist, next_hit)
	while target > max_x:
		target -= width
	while target < min_x:
		target += width
	
func _physics_process(delta):
	if not enabled or not started:
		return
		
	var width:float = max_x - min_x
	elapsed_time += delta
	possible_dist = min(possible_dist + rabbit_speed * delta, width)
	
	notice_timer += delta
	if notice_timer >= notice_interval:
		notice_timer -= notice_interval
		if has_new_report:
			has_new_report = false
			last_rabbit_pos = reported_pos
			possible_dist = min((elapsed_time - reported_time) * rabbit_speed, width)
			if randi() % 3 == 0:
				next_hit = (randi() % 2)
			else:
				next_hit = randf_range(0.0, 1.0)
	
	update_target()
	
	var farmer = get_parent()

	$Sprite2D.global_position.x = target
	
	var diff:float = farmer.global_position.x - target
	while diff > width/2:
		diff -= width
	while diff < -width/2:
		diff += width
	
	var should_attack:bool = abs(diff) < 5
	trigger_action("farmer_pitchfork", false)
	trigger_action("farmer_pitchfork", should_attack)
	if should_attack:
		next_hit = randf_range(0.0, 1.0)
		
		
	trigger_action("farmer_right", diff < 0)
	trigger_action("farmer_left", diff > 0)
	
func wiggle_at(x:float) -> void:
	reported_pos = x
	reported_time = elapsed_time
	has_new_report = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
