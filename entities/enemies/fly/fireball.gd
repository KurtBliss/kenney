extends AnimatedSprite2D
var multiply = 1
var direction = Vector2.ZERO

func _process(delta):
	rotate(0.2 * multiply)
	position += direction * 7
