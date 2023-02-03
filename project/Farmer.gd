extends Node2D

export var min_x: = 980
export var max_x: = 1920
export var speed: = 200.0
var stabbing_margin = 20
var is_stabbing: bool = false
onready var rabbit = get_node("/root/Game/RightMask/Rabbit")

func _ready():
	$Pitchfork.visible = false

func _physics_process(delta):
	if Input.is_action_pressed("farmer_pitchfork"):
		self.pitchfork_stab()
	else:
		self.pitchfork_disabled()
	
	var dir: = 0
	if Input.is_action_pressed("farmer_right"):
		dir += 1
	if Input.is_action_pressed("farmer_left"):
		dir -= 1
	
	# Farmer cannot move when pitchfork is in the ground
	if not self.is_stabbing:
		position.x += speed * delta * dir
	
	if global_position.x < min_x + 21:
		global_position.x += (max_x - min_x)
	elif global_position.x > max_x + 21:
		global_position.x -= (max_x - min_x)
	
	if dir > 0:
		$Sprite.flip_h = false
		$Sprite/Clone.flip_h = false
	elif dir < 0:
		$Sprite.flip_h = true
		$Sprite/Clone.flip_h = true
	
func pitchfork_stab():
	self.is_stabbing = true
	$Pitchfork.visible = true
	if rabbit.position.x <= self.position.x + stabbing_margin and rabbit.position.x >= self.position.x - stabbing_margin:
		rabbit.die()
	
func pitchfork_disabled():
	self.is_stabbing = false
	$Pitchfork.visible = false
