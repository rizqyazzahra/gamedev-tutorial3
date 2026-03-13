extends CharacterBody2D

@export var speed: float = 80.0
@export var patrol_distance: float = 100.0

var start_x: float
var direction: float = 1.0
var is_idle: bool = true
var is_dead: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

const GRAVITY = 980.0


func _ready() -> void:
	start_x = global_position.x
	anim.play("idle")

	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if is_idle:
		velocity.x = 0
		move_and_slide()
		return

	var left_bound  = start_x - patrol_distance
	var right_bound = start_x + patrol_distance

	if global_position.x >= right_bound:
		direction = -1.0
	elif global_position.x <= left_bound:
		direction = 1.0

	velocity.x = direction * speed

	anim.flip_h = direction < 0

	move_and_slide()


func _on_timer_timeout() -> void:
	if is_dead:
		return

	if is_idle:
		is_idle = false
		anim.play("walk")

	while not is_dead:
		anim.play("walk")
		timer.wait_time = 2.0
		timer.one_shot = true
		timer.start()
		await timer.timeout

		if is_dead:
			break

		anim.play("attack")
		timer.wait_time = 1.0
		timer.one_shot = true
		timer.start()
		await timer.timeout


func die() -> void:
	if is_dead:
		return
	is_dead = true
	timer.stop()
	velocity = Vector2.ZERO
	anim.play("dead")
	await anim.animation_finished
	queue_free()


func _on_body_entered(body: Node) -> void:
	if is_dead:
		return
	if body.is_in_group("player"):
		body.stop_bgm()
		body.sfx_lose.play()
		await body.sfx_lose.finished
		get_tree().reload_current_scene()
