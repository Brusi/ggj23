extends Node2D

const leftmost_carrot: = 1044.0
const carrot_diff: = 42.0

export var min_x: = 980
export var max_x: = 1920
export var speed: = 200.0
var stabbing_margin = 20

enum State {
	IDLE,
	WALKING,
	PREPARE,
	STAB,
	PULL,
}

var state:int = State.IDLE

onready var rabbit = get_node("/root/Game/RightMask/Rabbit")
var alive = true

var cooldown_bomb: = 0.0

onready var game: Game = get_parent().get_parent()

func is_occupied():
	return state == State.PREPARE or state == State.STAB or state == State.PULL

func _ready():
	$Pitchfork.visible = false
	get_node("/root/Game/LeftMask").clone_obj(self)

func copy_state_to(new_obj):
	new_obj.get_node("Sprite").flip_h = $Sprite.flip_h
	new_obj.get_node("Sprite/Clone") .flip_h = $Sprite/Clone.flip_h

func _physics_process(delta):
	if Input.is_action_just_pressed("farmer_pitchfork"):
		pitchfork_stab()
	
	var dir: = 0
	if Input.is_action_pressed("farmer_right"):
		dir += 1
	if Input.is_action_pressed("farmer_left"):
		dir -= 1
		
	if Input.is_action_just_pressed("farmer_action_1"):
		try_plant_bomb()
		pass
	
	# Farmer cannot move when pitchfork is in the ground
	if not is_occupied():
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
	state = State.PREPARE
	
	$Sprite.offset.y = -50
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	state = State.STAB
	
	$Sprite.offset.y = 0
	
	$Pitchfork.visible = true
	if rabbit.position.x <= position.x + stabbing_margin and rabbit.position.x >= position.x - stabbing_margin:
		rabbit.die()
		
	yield(get_tree().create_timer(2.0), "timeout")
	
	state = State.IDLE
	
	$Pitchfork.visible = false

	
func try_plant_bomb():
	var target_i = round((global_position.x - leftmost_carrot) / carrot_diff)
	if target_i < 0 or target_i >= 20:
		return
	var target_x = leftmost_carrot + target_i * carrot_diff
		
	for carrot in game.carrots:
		if !carrot.alive:
			continue
		if abs(carrot.global_position.x - target_x) < 10:
			return
			
	var bomb: = preload("res://Bomb.tscn").instance()
	game.add_child(bomb)
	bomb.global_position.x = target_x
	bomb.global_position.y = 550
	
			
	
	
