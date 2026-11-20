@tool

extends TextureButton

@export var label: = "text"
@export var color: = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label
	self_modulate = color


func _on_Button_mouse_entered():
	self_modulate = color - Color(0.1, 0.1, 0.1, 0.0)
	pass # Replace with function body.


func _on_Button_mouse_exited():
	self_modulate = color
	pass # Replace with function body.


func _on_Button_button_down():
	self_modulate = color - Color(0.2, 0.2, 0.2, 0.0)
	offset_top +=5
	offset_left += 5

func _on_Button_button_up():
	offset_top -= 5
	offset_left -= 5
	self_modulate = color - Color(0.1, 0.1, 0.1, 0.0)
