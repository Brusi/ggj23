extends Node2D

func _ready():
	pass # Replace with function body.

func _on_RabbitButton_pressed():
	Settings.farmer_ai = true
	Settings.rabbit_ai = false
	start_game()

func _on_VsButton_pressed():
	Settings.farmer_ai = false
	Settings.rabbit_ai = false
	start_game()

func _on_FarmerButton_pressed():
	Settings.farmer_ai = false
	Settings.rabbit_ai = true
	start_game()
	
func start_game() -> void:
	get_tree().change_scene("res://Splash.tscn")
