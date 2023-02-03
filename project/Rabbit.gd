extends Node2D

class_name Rabbit

export var min_x: = 980
export var max_x: = 1920

export var speed: = 200.0

onready var shape: RectangleShape2D = get_node("Area2D/CollisionShape2D").shape

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var dir: = 0
	if Input.is_action_pressed("rabbit_right"):
		dir += 1
	if Input.is_action_pressed("rabbit_left"):
		dir -= 1
	position.x += speed * delta * dir
	
	if position.x < min_x:
		position.x += (max_x - min_x)
	elif position.x > max_x:
		position.x -= (max_x - min_x)
	
	if dir > 0:
		$Sprite.flip_h = false
	elif dir < 0:
		$Sprite.flip_h = true
