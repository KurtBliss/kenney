extends EnemyHitDetection

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += 7
	rotation_degrees += 3 * signf(rotation_degrees)


func _on_body_entered(body):
	handle_player_body(body)
