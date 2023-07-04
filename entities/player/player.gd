class_name Player
extends CharacterBody2D
const SPEED = 380.0 * 60.0
const SLIDE = 960.0 * 60.0
const RUN = 580.0 * 60.0
const JUMP_VELOCITY = -669.0
const SPIN = 60 * 60
const ROLL = 500
@export_exp_easing("inout") var jump_charge_curve

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var is_ducking = false
var is_doward = false
var jumping = false # Used for camera
var can_jump_charge := false
var jump_charge : float = 1
var jump_start = position.y
var friction := 1000
var slide_direction = 0

@onready var jump_charge_particles : GPUParticles2D = $JumpChargeParticles
@onready var jump_charge_timer = $JumpChargeTimer
@onready var state_helper = $StateHelper
@onready var can_stand = $CanStand

### Built In Functions
func _ready():
	ref.player = self
	floor_constant_speed = true
	state_helper.reset("air")

func _process(delta): 
	state_helper.process(self, delta) 

func _physics_process(delta): 
	state_helper.phy_process(self, delta)



### States
func process_air(_delta):
	if is_on_floor():
		jumping = false
		state_helper.reset("ground")

func physics_air(delta):
	handle_gravity(delta)
	if Input.is_action_pressed("ui_down") \
	and Input.is_action_just_pressed("ui_accept"):
		velocity.y -= JUMP_VELOCITY 
		state_helper.reset("downward")
	handle_jump_control()
	handle_horizontal_movement(delta)
	handle_post_movement(delta)

func process_downward(_delta):
	if is_on_floor():
		var normal = get_floor_normal()
		if normal.y < -0.9:
			state_helper.reset("ground")
		else:
			floor_snap_length = 30
			state_helper.reset("slide")
			slide_direction = signf(normal.x)

func physics_downward(delta):
	if Input.is_action_pressed("ui_down") \
	and Input.is_action_just_pressed("ui_accept"):
		velocity.y -= JUMP_VELOCITY 
	handle_gravity(delta)
	handle_horizontal_movement(delta)
	handle_post_movement(delta)

func process_ground(_delta):
	if not is_on_floor():
		state_helper.reset("air")
	if Input.is_action_pressed("ui_down"):
		start_duck_state()

func physics_ground(delta):
	floor_snap_length = 10
	handle_ground_jump()
	handle_horizontal_movement(delta)
	handle_post_movement(delta)

func start_duck_state():
	state_helper.reset("duck")
	can_jump_charge = false
	jump_charge_timer.start()

func process_duck(_delta):
	if not Input.is_action_pressed("ui_down") \
	and can_stand.can_stand():
		end_duck_state()
	if can_jump_charge:
		jump_charge_particles.emitting = true
		jump_charge = minf(jump_charge + 0.015, 1.67)
		jump_charge_particles.self_modulate.a = jump_charge / 1.67

func physics_duck(delta):
	#if can_stand.can_stand():
	if not can_stand.can_stand():
		can_jump_charge = false
		jump_charge_particles.emitting = false
	if handle_ground_jump() and can_stand.can_stand():
		end_duck_state("air")
	if is_on_ceiling():
		velocity.y = 0
#	var dir = get_direction()
#	print(velocity.x)
#	if dir > 0 and velocity.x < ROLL:
#		velocity.x = SPIN * delta
#	elif dir < 0 and velocity.x > -ROLL:
#		velocity.x = -SPIN * delta
#	if get_direction():
#		velocity.x = lerp(velocity.x, velocity.x + get_direction() * ROLL, 0.4)
#		if velocity.x > ROLL:
#			velocity.x = ROLL
#		elif velocity.x < -ROLL:
#			velocity.x = -ROLL
#		velocity.x = get_direction() * ROLL * delta
	handle_gravity(delta)
	handle_post_movement(delta)

func end_duck_state(state = "ground"):
	can_jump_charge = false
	jump_charge_particles.emitting = false
	jump_charge = 1
	state_helper.reset(state)

func process_slide(_delta):
	if not is_on_floor():
		state_helper.reset("air")
	if get_floor_normal().y < -0.9:
		state_helper.reset("ground")

func physics_slide(delta):
	velocity.x = slide_direction * SLIDE * delta
	handle_ground_jump()
	handle_post_movement(delta)




### Behaviors
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_horizontal_movement(delta):
	velocity.x = get_direction() * get_speed() * delta

func handle_ground_jump() -> bool:
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY * jump_charge
		# Give jump boast if holding run key
		velocity.y += JUMP_VELOCITY * 0.05 if get_speed() > SPEED else 0
		floor_snap_length = 0
		jumping = true
		jump_start = position.y
		return true
	return false

func handle_jump_control():
	if Input.is_action_just_released("ui_accept") \
	and velocity.y < 0:
		velocity.y *= 0.35

func handle_post_movement(delta):
	velocity.x = move_toward(velocity.x, 0, friction * delta)
	move_and_slide()
	apply_floor_snap()



### Get
func get_direction():
	return Input.get_axis("ui_left", "ui_right")

func get_speed():
	return RUN if Input.is_action_pressed("run") else SPEED



### Virtual
func _on_jump_charge_timer_timeout():
	can_jump_charge = true


