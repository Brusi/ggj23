extends Node2D

class_name Carrot

var attached := true
var being_pulled_for = 0.0
onready var shape: RectangleShape2D = get_node("Area2D/CollisionShape2D").shape
onready var rabbit: Rabbit = get_parent().get_parent().get_node("Rabbit")
onready var game: Game = get_parent().get_parent()
var out := 0.0
var speed := 0.0
var fade_out_delay := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	game.carrots.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not attached:
		if position.y + shape.extents.y < rabbit.position.y + rabbit.shape.extents.y:
			speed += 10
			position.y += speed * delta
	else:
		pass
