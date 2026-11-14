extends Node
class_name AIComponent

"""
Makes decisions for creatures
"""

enum SprayReaction {
    FLEE,
    IGNORE,
    STUN_THEN_FLEE
}

enum State {
    CHASING,
    FLEEING
}

@export_group("Settings")
@export var global_player_ref: bool = false
@export var spray_reaction: SprayReaction = SprayReaction.FLEE

@export_group("External Nodes")
@export var body: CharacterBody2D

var state: State = State.CHASING
var player_ref: Player = null # Set on spawn or through a detection system
var move_vector: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
    match state:
        State.CHASING:
            if global_player_ref and player_ref != null:
                move_vector = body.global_position.direction_to(player_ref.global_position)
        
        State.FLEEING:
            if global_player_ref and player_ref != null:
                move_vector = body.global_position.direction_to(player_ref.global_position).rotated(deg_to_rad(180))

func handle_hurtbox(hurtbox: Hurtbox) -> void:
    if hurtbox.stored_hitbox != null:
        match spray_reaction:
            SprayReaction.FLEE:
                state = State.FLEEING