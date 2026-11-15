extends CharacterBody2D
class_name Creature

@export_group("Internal Nodes")
@export var ai_cmp: AIComponent
@export var movement_cmp: MovementComponent
@export var animation_cmp: AnimationComponent
@export var spray_hurtbox: Hurtbox
@export var stink_hurtbox: Hurtbox
@export var death_hurtbox: Hurtbox

@export_group("Resources")
@export var ghost_res: PackedScene

var faint_started: bool = false

func _process(_delta: float) -> void:
    animation_cmp.handle_facing_direction(self)

func _physics_process(_delta: float) -> void:
    if death_hurtbox != null and death_hurtbox.stored_hitbox != null:
        queue_free()

    ai_cmp.handle_spray_hurtbox(spray_hurtbox)
    ai_cmp.handle_stink_hurtbox(stink_hurtbox)
    if ai_cmp.state == ai_cmp.State.COUGHING:
        animation_cmp.cough()
    if ai_cmp.state == ai_cmp.State.FAINTING and not faint_started:
        faint()

    movement_cmp.accelerate(self, ai_cmp.move_vector)
    
    move_and_slide()

func faint() -> void:
    faint_started = true
    animation_cmp.faint()
    await animation_cmp.animation_finished
    animation_cmp.disabled = true # Avoid idle animation
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate:a", 0, 1)
    tween.tween_callback(spawn_ghost)
    tween.tween_callback(queue_free)

func spawn_ghost() -> void:
    print("spawn ghost")
    if ai_cmp.determine_ghost_spawn():
        var ghost: Creature = ghost_res.instantiate()
        ghost.global_position = global_position
        get_parent().add_child(ghost)