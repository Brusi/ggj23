extends Sprite

const SPEED = 200
const DURATION = 0.1

var vel:= Vector2.RIGHT.rotated(rand_range(-PI,PI)) * SPEED

func _physics_process(delta):
	position += vel * delta
	modulate.g -= delta / DURATION
	scale.x -= delta / DURATION
	scale.y -= delta / DURATION
	if scale.x <= 0:
		queue_free()
	

