extends Node
class_name AIComponent

"""
Makes decisions for creatures
"""

@export_group("Settings")
@export var global_player_ref: bool = false

@export_group("External Nodes")
@export var body: CharacterBody2D

var player_ref: Player = null # Set on spawn or through a detection system
var move_vector: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
    if global_player_ref and player_ref != null:
        move_vector = body.global_position.direction_to(player_ref.global_position)
