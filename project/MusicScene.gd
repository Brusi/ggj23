extends Node

export var music: = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if music:
		$MusicIntro.play()


func _on_MusicIntro_finished():
	$MusicIntro.stop()
	$MusicLoop.play()
