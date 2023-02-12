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
	update_score_texts()

func _process(delta):
	if Input.is_action_just_pressed("restart") or (ended and Input.is_action_just_pressed("ui_accept")):
		get_tree().reload_current_scene()
	elif Input.is_action_just_pressed("ui_accept") and splash:
		get_tree().change_scene("res://Game.tscn")
	elif Input.is_action_just_pressed("ui_cancel") and not splash:
		get_tree().change_scene("res://Splash.tscn")
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	#print(Engine.get_frames_per_second())
	
func end():
	ended = true

func rabbit_wins():
	player_wins($GUI/rabbit_wins)

func farmer_wins():
	player_wins($GUI/farmer_wins)

func player_wins(wins_gui):
	ended = true
	wins_gui.visible = true

func update_score_texts():
	farmer_counter.text = str(10 - collected_carrots)
	rabbit_counter.text = str(collected_carrots) + " / 10"

func collect_carrot():
	collected_carrots += 1
	update_score_texts()
	
	if collected_carrots >= 10:
		rabbit_wins()
