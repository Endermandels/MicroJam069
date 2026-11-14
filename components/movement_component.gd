extends Node
class_name MovementComponent

@export_group("Settings")
@export var acceleration: float = 0.2
@export var deceleration: float = 0.1
@export var max_speed: float = 200.0

func accelerate(body: CharacterBody2D, dir: Vector2) -> void:
	body.velocity = body.velocity.lerp(dir * max_speed, acceleration)

func decelerate(body: CharacterBody2D) -> void:
	body.velocity = body.velocity.lerp(Vector2.ZERO, deceleration)
