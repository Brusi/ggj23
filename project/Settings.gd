extends Node

export var music_on: = true
export var sound_on: = true

export var rabbit_ai: = false
export var farmer_ai: = false



func _ready():
	if music_on:
		$MusicIntro.play()

func _on_MusicIntro_finished():
	$MusicIntro.stop()
	$MusicLoop.play()
