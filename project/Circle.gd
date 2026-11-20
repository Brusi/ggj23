extends Sprite2D

const SPEED = 200
var duration = randf_range(0.5, 0.1)

var vel:= Vector2.RIGHT.rotated(randf_range(-PI,PI)) * randf_range(SPEED / 3, SPEED)

func _physics_process(delta):
	position += vel * delta
	modulate.g -= delta / duration
	scale.x -= delta / duration
	scale.y -= delta / duration
	if scale.x <= 0:
		queue_free()
	
