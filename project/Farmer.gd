extends Node2D

const leftmost_carrot: = 1060.0 - 46.4
const carrot_diff: = 46.4

@export var min_x: = 980
@export var max_x: = 1920
@export var speed: = 300.0
const stabbing_margin = 40

@export var pitcfork_miss_sound_delay: = 0.3
@export var pitcfork_cooldown: = 1.5

enum State {
	IDLE,
	WALKING,
	PREPARE,
	STAB,
	BOMB,
}

var state:int = State.IDLE

@onready var rabbit = get_node("/root/Game/RightMask/Rabbit")
var alive = true

var cooldown_bomb: = 0.0

@onready var game: Game = get_parent().get_parent()

var decoy:Node2D

var can_play_step: = true

func is_occupied():
	return state == State.PREPARE or state == State.STAB or state == State.BOMB
	
func play_step_sound():
	if not can_play_step:
		return
		
	can_play_step = false
	$Steps.get_child(randi() % $Steps.get_child_count()).play()
	await get_tree().create_timer(0.2).timeout
	can_play_step = true

func _ready():
	$Sprite2D.play("default")
	get_node("/root/Game/LeftMask").clone_obj(self)
	global_position.x = lerp(min_x, max_x, 0.5)

func copy_state_to(new_obj):
	for s in [[new_obj.get_node("Sprite2D") ,$Sprite2D],
			  [new_obj.get_node("Sprite2D/Clone"), $Sprite2D/Clone]]:
		s[0].flip_h = s[1].flip_h
		s[0].offset = s[1].offset
		s[0].visible = s[1].visible
		(s[0] as AnimatedSprite2D).play((s[1] as AnimatedSprite2D).animation)
	
func _physics_process(delta):
	if game.ended:
		return
	
	if Input.is_action_just_pressed("farmer_pitchfork"):
		pitchfork_stab()
	
	var dir: = 0
	if Input.is_action_pressed("farmer_right"):
		dir += 1
	if Input.is_action_pressed("farmer_left"):
		dir -= 1
		
	if dir != 0:
		if !is_occupied():
			$Sprite2D.play("walk")
			$Sprite2D/Clone.play("walk")
		play_step_sound()
	elif state == State.IDLE:
		if !is_occupied():
			$Sprite2D.play("default")
			$Sprite2D/Clone.play("default")
		
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
	
	if !is_occupied():
		if dir > 0:
			$Sprite2D.flip_h = true
			$Sprite2D/Clone.flip_h = true
		elif dir < 0:
			$Sprite2D.flip_h = false
			$Sprite2D/Clone.flip_h = false
	
func pitchfork_stab():
	if is_occupied():
		return

	state = State.PREPARE
	
	$Sprite2D.play("stab_one")
	$Sprite2D/Clone.play("stab_one")
	
	await get_tree().create_timer(0.2).timeout
	
	state = State.STAB
	$Stab.get_child(randi() % $Stab.get_child_count()).play()
	
	$Sprite2D.play("stab_two")
	$Sprite2D/Clone.play("stab_two")
	
	var cooldown = pitcfork_cooldown
	
	if rabbit.position.x <= position.x + stabbing_margin and rabbit.position.x >= position.x - stabbing_margin:
		rabbit.die()
	else:
		cooldown -= pitcfork_miss_sound_delay
		await get_tree().create_timer(pitcfork_miss_sound_delay).timeout
		$Grunt.get_child(randi() % $Grunt.get_child_count()).play()
		
	await get_tree().create_timer(cooldown).timeout
	
	state = State.IDLE
	$Sprite2D.play("default")
	
func try_plant_bomb():
	var bombs: = get_tree().get_nodes_in_group("bomb") 
	if is_occupied():
		return
	if not bombs.is_empty():
		return
	
	var target_i = round((global_position.x - leftmost_carrot) / carrot_diff)
	if target_i < 0 or target_i >= 20:
		return
	var target_x = leftmost_carrot + target_i * carrot_diff
		
	for carrot in game.carrots:
		if !carrot.alive:
			continue
		if abs(carrot.global_position.x - target_x) < 10 and carrot.attached:
			return
			
	for bomb in bombs:
		if !bomb.alive:
			continue
		if abs(bomb.global_position.x - target_x) < 10:
			return
			
	state = State.BOMB
	$Sprite2D.play("plant")
	$Sprite2D/Clone.play("plant")
	$Plant.play()
	
	await get_tree().create_timer(0.4).timeout
	
			
	var bomb: = preload("res://Bomb.tscn").instantiate()
	game.add_child(bomb)
	bomb.global_position.x = target_x
	bomb.global_position.y = 541

	$Sprite2D.play("default")
	$Sprite2D/Clone.play("default")
	
	state = State.IDLE
	

func _on_Rabbit_pulling(x:float):
	if x < min_x:
		# Hack to prevent clone from emitting.
		return
	# Add some minor timeout to make it feel human
	$AI.wiggle_at(x)
