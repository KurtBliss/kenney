extends EnemyHitDetection
@onready var fly = $".."
@onready var animation_player = $"../AnimationPlayer"
@onready var collision_shape_2d = $"../CollisionShape2D"
@onready var my_collision_shape_2d = $CollisionShape2D

func _on_body_entered(body):
	if body is Player:
		if body.is_doward:
			animation_player.play("dead")
			fly.state = fly.STATE_DEAD
			collision_shape_2d.disabled = true
			my_collision_shape_2d.disabled = true
		body.velocity.y = body.JUMP_VELOCITY
