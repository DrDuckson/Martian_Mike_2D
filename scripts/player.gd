extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@export var gravity = 400
@export var speed = 20
func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y += gravity*delta
		
	# nochmal überarbeiten!!!
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed*delta
	if Input.is_action_just_pressed("move_right"):
		velocity.x = +speed*delta
	if Input.is_action_just_pressed("jump"):
		pass
	move_and_slide()
