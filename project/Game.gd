extends Node2D

class_name Game

export var splash: = false
onready var farmer_counter = $GUI/farmer_counter
onready var rabbit_counter = $GUI/rabbit_counter


var collected_carrots := 0
var carrots := []

var ended: = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		
	print(Engine.get_frames_per_second())
	
func end():
	ended = true

func rabbit_wins():
	player_wins($GUI/rabbit_wins)

func farmer_wins():
	player_wins($GUI/farmer_wins)

func player_wins(wins_gui):
	ended = true
	wins_gui.visible = true

func collect_carrot():
	collected_carrots += 1
	farmer_counter.text = str(15 - collected_carrots)
	rabbit_counter.text = str(collected_carrots) + " / 15"
	
	if collected_carrots >= 15:
		rabbit_wins()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
