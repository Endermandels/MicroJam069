extends Node
class_name GunInputComponent

''' Specifically, take input from the keyboard, mouse, etc. '''

@export_group("Settings")
@export var external_shoot_call: bool = false ## Whether an external function will call shoot

@export_group("External Nodes")
@export var body: CharacterBody2D ## Body using inputs

var shoot_vector: Vector2 = Vector2.ZERO ## Normalized input vector for shooting
var shoot: bool = false ## Input for shooting

func _process(_delta: float) -> void:
    # Sticky input
    if not shoot:
        shoot = Input.is_action_pressed("shoot")
    
    if not external_shoot_call:
        get_shoot_vector()

func get_shoot_vector() -> void:
    shoot_vector = body.global_position.direction_to(body.get_global_mouse_position())
