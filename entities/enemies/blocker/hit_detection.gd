extends EnemyHitDetection
@onready var blocker = $".."
@onready var animation_player = $"../AnimationPlayer"


func _on_body_entered(body):
	if body is Player:
		if body.is_doward:
			blocker.state = blocker.STATE_DEAD
			animation_player.play("dead")
		body.velocity.y = body.JUMP_VELOCITY


