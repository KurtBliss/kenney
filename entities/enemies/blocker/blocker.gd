class_name EnemyBlocker
extends Enemy
enum {STATE_IDLE, STATE_CHASE, STATE_DEAD}
const SPEED = 120.0
const JUMP_VELOCITY = -400.0
@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer
var state = STATE_IDLE
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0

func _process(delta):
	match state:
		STATE_IDLE: state_idle()
		STATE_CHASE: state_chase()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func state_idle():
	if is_instance_valid(ref.player):
		ray_cast_2d.enabled = true
		ray_cast_2d.target_position = ref.player.global_position - global_position
		var col = ray_cast_2d.get_collider()
		if col == ref.player:
			state = STATE_CHASE
			ray_cast_2d.enabled = false
			animation_player.play("chase")
	else:
		ray_cast_2d.enabled = false

func state_chase():
	if is_instance_valid(ref.player):
		direction = sign(ref.player.global_position - global_position).x

func _on_health_dead():
	if state == STATE_DEAD:
		return
	state = STATE_DEAD
	animation_player.play("dead")
