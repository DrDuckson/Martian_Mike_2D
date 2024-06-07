extends Area2D

@export var jump_force = 300
@onready var animation_sprite = $AnimatedSprite2D

func _on_body_entered(body):
	if body is Player:
		animation_sprite.play("jump")
		body.jump(jump_force)
