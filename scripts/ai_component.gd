extends Node
class_name AIComponent

"""
Makes decisions for creatures
"""

enum SprayReaction {
    FLEE,
    IGNORE,
    STUN_THEN_FLEE,
    FAINT
}

enum StinkReaction {
    AVOID_STINK,
    COUGH,
    IGNORE,
}

enum State {
    CHASING,
    FLEEING,
    AVOIDING_STINK,
    COUGHING,
    FAINTING
}

@export_group("Settings")
@export var global_player_ref: bool = false
@export var spray_reaction: SprayReaction = SprayReaction.FLEE
@export var stink_reaction: StinkReaction = StinkReaction.AVOID_STINK
@export var fleeing_speed: float = 400 ## For Fleeing creatures only
@export var chance_to_spawn_ghost: float = 0.1 ## For Fainting creatures only

@export_group("External Nodes")
@export var body: CharacterBody2D
@export var movement_cmp: MovementComponent

const AVOID_STINK_TIME: float = 0.5

var state: State = State.CHASING
var player_ref: Player = null # Set on spawn or through a detection system
var stink_aoe_ref: Node2D = null
var move_vector: Vector2 = Vector2.ZERO
var repulsion_timer: Timer = Timer.new()
var spawn_ghost: bool = false

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
        
        State.COUGHING:
            if repulsion_timer.time_left <= 0:
                state = State.CHASING
            move_vector = Vector2.ZERO
        
        State.FAINTING:
            move_vector = Vector2.ZERO
            body.velocity = Vector2.ZERO

func handle_spray_hurtbox(hurtbox: Hurtbox) -> void:
    if hurtbox != null and hurtbox.stored_hitbox != null:
        match spray_reaction:
            SprayReaction.FLEE:
                state = State.FLEEING
                hurtbox.stored_hitbox = null
                movement_cmp.max_speed = fleeing_speed
            
            SprayReaction.FAINT:
                state = State.FAINTING
                hurtbox.stored_hitbox = null

func handle_stink_hurtbox(hurtbox: Hurtbox) -> void:
    if hurtbox != null and hurtbox.stored_hitbox != null:
        if state != State.FLEEING and state != State.FAINTING:
            match stink_reaction:
                StinkReaction.AVOID_STINK:
                    repulsion_timer.start()
                    state = State.AVOIDING_STINK
                    stink_aoe_ref = hurtbox.stored_hitbox.get_parent()
                    hurtbox.stored_hitbox = null
                
                StinkReaction.COUGH:
                    repulsion_timer.start()
                    state = State.COUGHING
                    hurtbox.stored_hitbox = null

func determine_ghost_spawn() -> bool:
    return randf() < chance_to_spawn_ghost
