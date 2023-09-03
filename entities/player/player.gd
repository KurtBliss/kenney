class_name Player
extends CharacterBody2D
const ACCELERATION = 100.0
const SPEED = 380.0 
const SLIDE = 960.0 
const RUN = 580.0 
const JUMP_VELOCITY = -669.0
const SPIN = 60 
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
var friction := 27
var slide_direction = 0
var can_jump = true

@onready var jump_charge_particles : GPUParticles2D = $JumpChargeParticles
@onready var jump_charge_timer = $JumpChargeTimer
@onready var state_helper = $StateHelper
@onready var can_stand = $CanStand
@onready var player = $"."
@onready var slide = $Slide

@export var vel : Vector2 = velocity

### Built In Functions
func _ready():
	ref.player = self
	floor_constant_speed = true
	state_helper.reset("air")

func _process(delta): 
	state_helper.process(self, delta) 
	vel = velocity

func _physics_process(delta): 
	state_helper.phy_process(self, )



### States
func process_air(_delta):
	if is_on_floor():
		jumping = false
		start_ground_state()

func physics_air(_delta):
	handle_gravity()
	if Input.is_action_pressed("ui_down") \
	and Input.is_action_just_pressed("ui_accept"):
		velocity.y -= JUMP_VELOCITY 
		state_helper.reset("downward")
		can_jump = false
	handle_jump()
	handle_jump_control()
	handle_horizontal_movement()
	handle_post_movement()

func process_downward(_delta):
	if is_on_floor():
		var normal = get_floor_normal()
		if normal.y < -0.9:
			start_ground_state()
		else:
			start_slide_state(normal)

func physics_downward(_delta):
	if Input.is_action_pressed("ui_down") \
	and Input.is_action_just_pressed("ui_accept"):
		velocity.y -= JUMP_VELOCITY 
	handle_gravity()
	handle_horizontal_movement()
	handle_post_movement()

func start_ground_state():
	state_helper.reset("ground")
	can_jump = true

func process_ground(_delta):
	if not is_on_floor():
		state_helper.reset("air")
	if Input.is_action_pressed("ui_down"):
		start_duck_state()

func physics_ground(_delta):
	floor_snap_length = 15
	handle_jump()
	handle_horizontal_movement()
	handle_post_movement()

func start_duck_state():
	state_helper.reset("duck")
	can_jump_charge = false
	jump_charge_timer.start()

func process_duck(_delta):
	if is_on_floor():
		can_jump = true
	if not Input.is_action_pressed("ui_down") \
	and can_stand.can_stand():
		end_duck_state()
	if can_jump_charge:
		jump_charge_particles.emitting = true
		jump_charge = minf(jump_charge + 0.015, 1.67)
		jump_charge_particles.self_modulate.a = jump_charge / 1.67

func physics_duck(_delta):
	if not can_stand.can_stand():
		can_jump_charge = false
		jump_charge_particles.emitting = false
	if handle_jump() and can_stand.can_stand():
		end_duck_state("air")
	if !is_on_floor() and not can_stand.can_stand():
		handle_horizontal_movement(0.5)
	if is_on_ceiling():
		velocity.y = 0
	handle_gravity()
	handle_post_movement()

func end_duck_state(state = "ground"):
	can_jump_charge = false
	jump_charge_particles.emitting = false
	jump_charge = 1
	if state == "ground":
		start_ground_state()
	else:
		state_helper.reset(state)

func start_slide_state(normal):
	floor_snap_length = 30
	state_helper.reset("slide")
	slide_direction = signf(normal.x)
	slide.play("on")

func end_slide_state(state):
	slide.play("off")
	if state == "ground":
		start_ground_state()
	state_helper.reset(state)

func process_slide(_delta):
	if not is_on_floor():
		end_slide_state("air")
	if get_floor_normal().y < -0.9:
		end_slide_state("ground")

func physics_slide(_delta):
	velocity.x = slide_direction * SLIDE
	handle_jump()
	handle_post_movement()




### Behaviors
func handle_gravity():
	if not is_on_floor():
		velocity.y += gravity

func handle_horizontal_movement(mul = 1):
	#velocity.x = get_direction() * get_speed() * 
	#velocity.x = move_toward(velocity.x, velocity.x + get_speed() * get_direction() * , ACCELERATION * )
	
	var dir = get_direction()

	# Move Right
	if dir > 0:
		if velocity.x < get_speed() * mul:
			velocity.x = max(velocity.x + ACCELERATION * mul, get_speed() * mul)
			prints(velocity.x, get_speed() * mul)
			

	# Move Left
	elif dir < 0:
		if velocity.x > -get_speed() * mul:
			velocity.x = min(velocity.x - ACCELERATION * mul, -get_speed() * mul)
			prints(velocity.x, get_speed() * mul)



func handle_jump() -> bool:
	if Input.is_action_just_pressed("ui_accept") and can_jump:
		velocity.y = JUMP_VELOCITY * jump_charge
		# Give jump boast if holding run key
		velocity.y += JUMP_VELOCITY * 0.05 if get_speed() > SPEED else 0
		floor_snap_length = 0
		jumping = true
		jump_start = position.y
		can_jump = false
		return true
	return false

func handle_jump_control():
	if Input.is_action_just_released("ui_accept") \
	and velocity.y < 0:
		velocity.y *= 0.35

func handle_post_movement():
	velocity.x = move_toward(velocity.x, 0, friction)
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


