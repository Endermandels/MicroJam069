extends CharacterBody2D
class_name ProjectileComponent

enum ProjectileType {
    MISSILE,
    GRENADE
}

@export_group("Settings")
@export var projectile_type: ProjectileType = ProjectileType.MISSILE
@export_subgroup("Missile")
@export var missile_rocket_time: float = 0.5 ## How long until missile_deceleration kicks in
@export var missile_explode_thresh: float = 15 ## How low speed has to be to explode
@export_subgroup("Grenade")
@export var grenade_explode_thresh: float = 15 ## How low speed has to be to explode

@export_group("Internal Nodes")
@export var movement_cmp: MovementComponent
@export var anim_player: AnimationPlayer

var input_vector: Vector2 = Vector2.RIGHT
var accelerating: bool = true

func _ready() -> void:
    match (projectile_type):
        ProjectileType.MISSILE:
            # Rocket fuel lasts a limited amount of time
            var timer = get_tree().create_timer(missile_rocket_time)
            timer.timeout.connect(start_decelerating)

        ProjectileType.GRENADE:
            # Grenade is lobbed at speed
            velocity = movement_cmp.max_speed * input_vector
            accelerating = false

func _physics_process(_delta: float) -> void:
    if accelerating:
        movement_cmp.accelerate(self, input_vector)
    else:
        movement_cmp.decelerate(self)

    match (projectile_type):
        ProjectileType.MISSILE:
            if velocity.length() < missile_explode_thresh \
                and anim_player.current_animation != "explode" \
                and not accelerating:
                explode()
        
        ProjectileType.GRENADE:
            if velocity.length() < grenade_explode_thresh \
                and anim_player.current_animation != "explode":
                explode()

    move_and_slide()

func explode() -> void:
    rotation = 0 # Explode animation should always be not rotated
    velocity = Vector2.ZERO # Should not be moving while exploding
    anim_player.play("explode")
    await anim_player.animation_finished
    queue_free()

func start_decelerating() -> void:
    accelerating = false