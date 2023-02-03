extends Node2D

class_name Rabbit

export var min_x: = 980
export var max_x: = 1920
export var speed: = 200.0
export var after_pull_delay: = 1.0
export var pulling_time: = 2.5
export var carrot_margin := 10
var is_dead: bool = false

var current_action = ""
var pulling_delay = 0.0
var pulling := false

const ACTIONS = ["rabbit_right", "rabbit_left", "rabbit_down"]

onready var shape: RectangleShape2D = get_node("Area2D/CollisionShape2D").shape
onready var game: Game = get_parent()

func _ready():
	pass

func _pull_carrot(delta) -> bool:
	var carrot = null
	for possible_carrot in game.carrots:
		if possible_carrot.global_position.x - carrot_margin <= global_position.x and possible_carrot.global_position.x + carrot_margin >= global_position.x and possible_carrot.attached:
			carrot = possible_carrot
			break
	
	if not carrot:
		return false
	
	carrot.being_pulled_for += delta
	carrot.out += delta / pulling_time
	
	carrot.position.y += 20 * (delta / pulling_time)
	
	if carrot.out >= 1:
		carrot.attached = false
	
	return true
	

func _physics_process(delta):	
	if not self.is_dead:
		if pulling_delay >= delta:
			pulling_delay -= delta
		else:
			delta -= pulling_delay
			pulling_delay = 0.0
			
			var next_action = ""
			
			if current_action != "" and Input.is_action_pressed(current_action):
				next_action = current_action
			else:
				for possible_action in ACTIONS:
					if Input.is_action_pressed(possible_action):
						if next_action == "":
							next_action = possible_action
						else:
							# Two keys are pressed, do nothing
							next_action = ""
							break

			current_action = next_action
			
			if pulling and current_action != "rabbit_down":
				pulling_delay = after_pull_delay
				pulling = false
			else:
				var dir: = 0
				if current_action == "rabbit_right":
					dir += 1
				if current_action == "rabbit_left":
					dir -= 1
			
				position.x += speed * delta * dir

				if dir > 0:
					$Sprite.flip_h = false
					$Sprite/Clone.flip_h = false
				elif dir < 0:
					$Sprite.flip_h = true
					$Sprite/Clone.flip_h = true
				
				if current_action == "rabbit_down":
					var pulled_before = pulling
					pulling = _pull_carrot(delta)
					
					if pulled_before and not pulling:
						current_action = ""
						pulling_delay = after_pull_delay
				else:
					pulling = false
	
	if position.x < min_x - 21:
		position.x += (max_x - min_x)
	elif position.x > max_x - 21:
		position.x -= (max_x - min_x)

func die():
	self.is_dead = true
	$Sprite.flip_v = true
	
