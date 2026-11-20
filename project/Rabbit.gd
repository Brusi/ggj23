extends Node2D
class_name Rabbit

signal pulling


@export var min_x: = 980
@export var max_x: = 1920
@export var speed: = 200.0
@export var after_pull_delay: = 0.1
@export var pulling_time: = 1.5
@export var min_pull_time: = 0.3
@export var carrot_margin := 46.34 / 2
var is_dead: bool = false
var pulled_bomb := false

var current_action = ""
var pulling_delay = 0.0
var min_active_pulling_time = 0.0
var is_pulling := false

# This is "object alive", not "player alive"
var alive := true
var decoy:Node2D

var can_play_step: = true

const ACTIONS = ["rabbit_right", "rabbit_left", "rabbit_down"]

@onready var shape: RectangleShape2D = get_node("Area2D/CollisionShape2D").shape
@onready var game: Game = get_parent().get_parent()

func _ready():
	get_node("/root/Game/LeftMask").clone_obj(self)
	var init_x = randf_range(0.1, 0.4) + (randi() % 2) * 0.5
	position.x = lerp(min_x, max_x, init_x)

func copy_state_to(new_obj):
	for s in [[new_obj.get_node("Sprite2D") ,$Sprite2D],
			  [new_obj.get_node("Sprite2D/Clone"), $Sprite2D/Clone]]:
		s[0].flip_h = s[1].flip_h
		s[0].flip_v = s[1].flip_v
		s[0].offset = s[1].offset
		s[0].visible = s[1].visible
		s[0].play(s[1].animation)

func _pull_bomb():
	for bomb in get_tree().get_nodes_in_group("bomb"):
		if not bomb.alive:
			continue
		if abs(bomb.global_position.x - global_position.x) < 21:
			bomb.falling = true
			pulling_delay = 1.0
			pulled_bomb = true
			

func is_dead_or_about_to() -> bool:
	return pulled_bomb or is_dead

func _pull_carrot(delta) -> bool:
	var carrot = null
	for possible_carrot in game.carrots:
		if possible_carrot.global_position.x - carrot_margin <= global_position.x and possible_carrot.global_position.x + carrot_margin >= global_position.x and possible_carrot.attached:
			carrot = possible_carrot
			break
	
	if not carrot:
		return false
		
	global_position.x += (carrot.global_position.x - global_position.x) * 0.375 / pulling_time
	
	carrot.being_pulled_for += delta
	carrot.out += delta / pulling_time
	
	carrot.position.y += 20 * (delta / pulling_time)
	
	if carrot.out >= 1:
		carrot.attached = false
		game.collect_carrot()
		
	emit_signal("pulling", global_position.x)
	
	return true
	
func play_step_sound():
	if not can_play_step:
		return
		
	can_play_step = false
	$Steps.get_child(randi() % $Steps.get_child_count()).play()
	await get_tree().create_timer(0.1).timeout
	can_play_step = true

func _physics_process(delta):
	if game.ended:
		return
	
	if not self.is_dead:
		if pulling_delay >= delta:
			pulling_delay -= delta
		else:
			delta -= pulling_delay
			pulling_delay = 0.0
			
			if Input.is_action_just_pressed("rabbit_down"):
				_pull_bomb()
			
			var next_action = ""
			
			if current_action != "" and Input.is_action_pressed(current_action):
				next_action = current_action
			elif min_active_pulling_time >= delta and is_pulling:
				min_active_pulling_time -= delta
				next_action = "rabbit_down"
			else:
				min_active_pulling_time = 0
				for possible_action in ACTIONS:
					if Input.is_action_pressed(possible_action):
						if next_action == "":
							next_action = possible_action
						else:
							# Two keys are pressed, do nothing
							next_action = ""
							break

			current_action = next_action
			
			if is_pulling and current_action != "rabbit_down":
				pulling_delay = after_pull_delay
				is_pulling = false
			else:
				var dir: = 0
				if current_action == "rabbit_right":
					dir += 1
				if current_action == "rabbit_left":
					dir -= 1
					
				if is_pulling:
					$Sprite2D.play("pull")
					$Sprite2D/Clone.play("pull")
				elif dir != 0:
					$Sprite2D.play("run")
					$Sprite2D/Clone.play("run")
				else:
					$Sprite2D.play("idle")
					$Sprite2D/Clone.play("idle")
			
				position.x += speed * delta * dir

				if dir > 0:
					$Sprite2D.flip_h = false
					$Sprite2D/Clone.flip_h = false
					play_step_sound()
				elif dir < 0:
					$Sprite2D.flip_h = true
					$Sprite2D/Clone.flip_h = true
					play_step_sound()
				
				if current_action == "rabbit_down":
					var pulled_before = is_pulling
					is_pulling = _pull_carrot(delta)
					
					if not pulled_before and is_pulling:
						min_active_pulling_time = min_pull_time
					
					if pulled_before and not is_pulling:
						current_action = ""
						pulling_delay = after_pull_delay
				else:
					is_pulling = false
	
	if global_position.x < min_x - 21:
		global_position.x += (max_x - min_x)
	elif global_position.x > max_x - 21:
		global_position.x -= (max_x - min_x)

func die_by_bomb():
	die()

func die():
	self.is_dead = true
	$Die.play()
	$Sprite2D.play("dead")
	$Sprite2D/Clone.play("dead")
	if game.splash:
		await get_tree().create_timer(1.5).timeout
		pulled_bomb = false
		is_dead = false
		pulling_delay = 0.0
	else:
		game.farmer_wins()
