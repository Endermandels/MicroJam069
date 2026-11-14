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

enum StinkReaction {
    AVOID_STINK,
    SLOW_STUN,
    IGNORE,
}

enum State {
    CHASING,
    FLEEING,
    AVOIDING_STINK,
    BEING_STUNNED_SLOWLY
}

@export_group("Settings")
@export var global_player_ref: bool = false
@export var spray_reaction: SprayReaction = SprayReaction.FLEE
@export var stink_reaction: StinkReaction = StinkReaction.AVOID_STINK
@export var fleeing_speed: float = 400

@export_group("External Nodes")
@export var body: CharacterBody2D
@export var movement_cmp: MovementComponent

const AVOID_STINK_TIME: float = 0.5

var state: State = State.CHASING
var player_ref: Player = null # Set on spawn or through a detection system
var stink_aoe_ref: Node2D = null
var move_vector: Vector2 = Vector2.ZERO
var repulsion_timer: Timer = Timer.new()

func _ready() -> void:
    repulsion_timer.wait_time = AVOID_STINK_TIME
    repulsion_timer.one_shot = true
    add_child(repulsion_timer)

func _physics_process(_delta: float) -> void:
    match state:
        State.CHASING:
            if global_player_ref and player_ref != null:
                move_vector = body.global_position.direction_to(player_ref.global_position)
        
        State.FLEEING:
            if global_player_ref and player_ref != null:
                move_vector = body.global_position.direction_to(player_ref.global_position).rotated(deg_to_rad(180))
        
        State.AVOIDING_STINK:
            if repulsion_timer.time_left <= 0:
                state = State.CHASING
            if stink_aoe_ref != null:
                move_vector = body.global_position.direction_to(stink_aoe_ref.global_position).rotated(deg_to_rad(180))

func handle_spray_hurtbox(hurtbox: Hurtbox) -> void:
    if hurtbox.stored_hitbox != null:
        match spray_reaction:
            SprayReaction.FLEE:
                state = State.FLEEING
                hurtbox.stored_hitbox = null
                movement_cmp.max_speed = fleeing_speed

func handle_stink_hurtbox(hurtbox: Hurtbox) -> void:
    if hurtbox.stored_hitbox != null:
        match stink_reaction:
            StinkReaction.AVOID_STINK:
                if state != State.FLEEING:
                    repulsion_timer.start()
                    state = State.AVOIDING_STINK
                    stink_aoe_ref = hurtbox.stored_hitbox.get_parent()
                    hurtbox.stored_hitbox = null
