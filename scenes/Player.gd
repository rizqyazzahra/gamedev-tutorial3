extends CharacterBody2D

@export var gravity = 500.0
@export var walk_speed = 200
@export var jump_speed = -200
@export var max_jumps = 2

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

var jump_counts = 0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += delta * gravity
	else:
		jump_counts = 0
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -walk_speed
		if is_on_floor():
			sprite.flip_h = true
			animation.play("Walk")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = walk_speed
		if is_on_floor():
			sprite.flip_h = false
			animation.play("Walk")
	else:
		velocity.x = 0
		if is_on_floor():
			animation.play("Idle")
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or jump_counts < max_jumps:
			velocity.y = jump_speed
			jump_counts += 1
			animation.play("Jump")
		
	move_and_slide()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	pass
	
