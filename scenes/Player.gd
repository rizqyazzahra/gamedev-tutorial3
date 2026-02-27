extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var jump_speed = -200
@export var crouch_speed = 80
@export var slide_speed = 300
@export var slide_duration = 0.4
@export var max_jumps = 3

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var stand_collision = $StandCollision
@onready var crouch_collision = $CrouchCollision

var jump_counts = 0
var is_crouching = false
var is_sliding = false
var slide_timer = 0.0
var slide_direction = 1
var is_finished = false

func _physics_process(delta):
	if is_finished:
		velocity.x = 0
		if is_on_floor():
			animation.play("Cheer")
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += delta * gravity
	else:
		jump_counts = 0

	if is_sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			is_sliding = false

	is_crouching = Input.is_action_pressed("ui_down") and is_on_floor() and not is_sliding

	if Input.is_action_pressed("ui_down") and is_on_floor() and not is_sliding:
		if Input.is_action_just_pressed("ui_left"):
			is_sliding = true
			slide_timer = slide_duration
			slide_direction = -1
			sprite.flip_h = true
		elif Input.is_action_just_pressed("ui_right"):
			is_sliding = true
			slide_timer = slide_duration
			slide_direction = 1
			sprite.flip_h = false

	if is_sliding:
		velocity.x = slide_direction * slide_speed
	else:
		var speed = crouch_speed if is_crouching else walk_speed
		if Input.is_action_pressed("ui_left"):
			velocity.x = -speed
			sprite.flip_h = true
		elif Input.is_action_pressed("ui_right"):
			velocity.x = speed
			sprite.flip_h = false
		else:
			velocity.x = 0

	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or jump_counts < max_jumps:
			velocity.y = jump_speed
			jump_counts += 1
			is_crouching = false
			is_sliding = false

	move_and_slide()
	_update_animation()
	_update_collision()

func _update_animation():
	if is_sliding:
		animation.play("Slide")
	elif is_crouching:
		animation.play("Duck")
	elif not is_on_floor():
		if velocity.y < 0:
			animation.play("Jump")
		else:
			animation.play("Fall")
	elif velocity.x != 0:
		animation.play("Walk")
	else:
		animation.play("Idle")
		
func _update_collision():
	var is_low = is_crouching or is_sliding
	stand_collision.disabled = is_low
	crouch_collision.disabled = not is_low
	
func on_reach_finish():
	is_finished = true
	velocity = Vector2.ZERO
	
func _ready() -> void:
	pass

func _process(delta):
	pass
