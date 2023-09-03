class_name EnemyFly
extends Enemy
enum {STATE_FLY, STATE_DEAD}
@onready var animated_sprite_2d = $AnimatedSprite2D
var state = STATE_FLY
var amplitude = 50  # The vertical distance of the fly's sinusoidal motion
var speed = 100  # The horizontal speed of the fly
var direction = 1  # The direction of the fly (1 for right, -1 for left)
var startY = 0  # The starting Y position of the fly
var health = 100
@onready var animation_player_hurt = $AnimationPlayerHurt
@onready var animation_player = $AnimationPlayer
var poop_scene = preload("res://entities/enemies/fly/poop.tscn")


func _ready():
	# Store the initial Y position of the fly
	startY = position.y
	animated_sprite_2d.play("default")

func _process(_delta):
	match state:
		STATE_FLY: state_fly()
		STATE_DEAD: state_dead()
	

func state_fly():
	# Calculate the new position of the fly
	velocity = Vector2(speed * direction, amplitude * sin(position.x / 50))
	move_and_slide()

	# Check if the fly has reached the screen edges
	if position.x > get_viewport().size.x or position.x < 0:
		direction *= -1  # Reverse the fly's direction

	# Add a slight up and down movement
	position.y = startY + amplitude * sin(position.x / 100)
	
	if velocity.x != 0:
		animated_sprite_2d.flip_h = true if velocity.x > 0 else false

func state_dead():
	position.y += 5
#	velocity = Vector2(0,300)
#	move_and_slide()

func _on_health_dead():
	if state == STATE_DEAD:
		return
	state = STATE_DEAD
	animation_player.play("dead")


func _on_timer_timeout():
	var poop = poop_scene.instantiate()
	ref.level.add_child(poop)
	poop.global_position = global_position
	poop.rotation_degrees = signf(velocity.x)
