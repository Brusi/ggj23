extends Node2D

class_name Carrot

signal collected

var attached := true
var being_pulled_for = 0.0
onready var shape: RectangleShape2D = get_node("Area2D/CollisionShape2D").shape
onready var rabbit: Rabbit = get_parent().get_parent().get_node("RightMask/Rabbit")
onready var game: Game = get_parent().get_parent()
var out := 0.0
var speed := 0.0
var fade_out_delay := 0.0
var rot_speed := 0.0
var rot_speed_diff := 0.0
var success_played: = false

var alive := true

var decoy:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	game.carrots.append(self)
	get_node("/root/Game/LeftMask").clone_obj(self)

func copy_state_to(new_obj):
	new_obj.get_node("CarrotGraphics").offset = $CarrotGraphics.offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if attached:
		rot_speed -= sign(rot_speed) * min(abs(rot_speed), 0.003 * 2 * PI)
		
		if being_pulled_for > 0:
			$PullSound.volume_db = 0.0
			if not $PullSound.playing:
				$PullSound.play()
			var use_delta = min(delta, being_pulled_for)
			being_pulled_for -= use_delta
			rot_speed_diff += use_delta
			rot_speed += 0.05 * 2 * PI * cos(PI * rot_speed_diff / 0.1)
			$CarrotGraphics.offset.x = 2 * cos(PI * rot_speed_diff / 0.01)
		else:
			$PullSound.volume_db = max(-1000, $PullSound.volume_db - 60 * delta)
			if $PullSound.volume_db < -100:
				$PullSound.volume_db = 0
				$PullSound.stop()
		
		if rotation > 0:
			rot_speed -= max(0, min(rotation / delta + rot_speed, 0.01 * 2 * PI))
		elif rotation < 0:
			rot_speed += max(0, min(-rotation / delta - rot_speed, 0.01 * 2 * PI))
		
		rotation += rot_speed * delta
	elif alive:
		$PullSound.stop()
		if global_position.y + shape.extents.y < rabbit.global_position.y + rabbit.shape.extents.y:
			speed += 10
			position.y += speed * delta
		else:
			if not $Success.playing and not success_played:
				success_played = true
				$Success.play()
			fade_out_delay += delta
			
			if fade_out_delay > 1.0 and fade_out_delay < 1.5:
				modulate.a = cos(PI * (min(fade_out_delay, 1.5) - 1.0) / 0.5)
			elif fade_out_delay >= 1.5:
				alive = false
				modulate.a = 0
