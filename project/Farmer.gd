extends Node2D

const leftmost_carrot: = 1044.0
const carrot_diff: = 42.0

export var min_x: = 980
export var max_x: = 1920
export var speed: = 200.0
var stabbing_margin = 20
var is_stabbing: bool = false
onready var rabbit = get_node("/root/Game/RightMask/Rabbit")

var cooldown_bomb: = 0.0

onready var game: Game = get_parent().get_parent()

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
		
	if Input.is_action_just_pressed("farmer_action_1"):
		try_plant_bomb()
		pass
	
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
	
func try_plant_bomb():
	var target_i = round((global_position.x - leftmost_carrot) / carrot_diff)
	if target_i < 0 or target_i >= 20:
		return
	var target_x = leftmost_carrot + target_i * carrot_diff
		
	for carrot in game.carrots:
		if !carrot.attached:
			continue
		if abs(carrot.global_position.x - target_x) < 10:
			return
			
	var bomb: = preload("res://Bomb.tscn").instance()
	game.add_child(bomb)
	bomb.global_position.x = target_x
	bomb.global_position.y = 550
	
			
	
	
