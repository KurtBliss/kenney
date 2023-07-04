class_name Player
extends CharacterBody2D
@export_exp_easing("inout") var jump_charge_curve
const SPEED = 380.0
const SLIDE = 960.0
const RUN = 580.0
const JUMP_VELOCITY = -669.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var is_ducking = false
var is_doward = false
var jumping = false
var can_jump_charge := false
var jump_charge : float = 1
var jump_start = position.y
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var jump_charge_particles : GPUParticles2D = $JumpCharge
@onready var jump_charge_timer = $JumpChargeTimer

func _ready():
	ref.player = self
	floor_constant_speed = true

func _physics_process(delta):
	var speed = RUN if Input.is_action_pressed("run") else SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_pressed("ui_down") \
		and Input.is_action_just_pressed("ui_accept"):
			velocity.y -= JUMP_VELOCITY 
			is_doward = true

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		is_doward = false
		velocity.y = JUMP_VELOCITY * jump_charge
		velocity.y += JUMP_VELOCITY * 0.1 if speed > SPEED else 0
		jump_start = position.y
		jumping = true
	elif is_on_floor():
		jumping = false
		if get_floor_angle() == 0:
			is_doward = false
	
	if Input.is_action_just_released("ui_accept") \
	and !is_on_floor() \
	and velocity.y < 0:
		velocity.y *= 0.35
	
	# Handle ducking.
	if Input.is_action_pressed("ui_down") and is_on_floor() and !is_doward:
		animation_player.play("duck")
		is_ducking = true
		if !can_jump_charge and jump_charge_timer.is_stopped():
			jump_charge_timer.start()
		if can_jump_charge:
			jump_charge_particles.emitting = true		
			jump_charge = minf(jump_charge + 0.015, 1.67)
			jump_charge_particles.self_modulate.a = jump_charge / 1.67
	elif is_ducking:
		animation_player.play("RESET")
		is_ducking = false
		jump_charge_timer.stop()
		can_jump_charge = false
		jump_charge_particles.emitting = false
		jump_charge = 1

	var direction = Input.get_axis("ui_left", "ui_right")
	var is_sliding = false
	
	if is_doward and is_on_floor():
		var face = -1 if get_floor_angle() < 0 else 1
		direction = face
		is_sliding = true
	
	if direction and not (is_ducking and is_on_floor()):
		if is_sliding:
			floor_snap_length = 30
			velocity.x = direction * SLIDE
		else:
			floor_snap_length = 10
			velocity.x = direction * speed
		
		animated_sprite_2d.flip_h = true if direction < 0 else false
		if is_on_floor() and !is_ducking and !is_doward:
			animated_sprite_2d.play("walk", speed / SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor() and !is_ducking and !is_doward:
			animated_sprite_2d.play("idle")
	if !is_on_floor() and !is_ducking:
		animated_sprite_2d.play("jump")

	animated_sprite_2d.flip_v = is_doward
	move_and_slide()
	apply_floor_snap()

func rotate_on_floor():
	if is_on_floor():
		animated_sprite_2d.rotation = \
		lerp_angle(animated_sprite_2d.rotation, get_floor_angle(), 0.9)
	else:
		animated_sprite_2d.rotation = \
		lerp_angle(animated_sprite_2d.rotation, 0, 0.9)

func _on_jump_charge_timer_timeout():
	can_jump_charge = true
	pass # Replace with function body.
