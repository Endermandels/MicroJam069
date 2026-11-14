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
@export var grenade_peak: float = 15 ## Peak of arc
@export var grenade_tilt: float = 0.5 ## How exaggerated is the tilt
@export var grenade_explode_thresh: float = 15 ## How low speed has to be to explode

@export_group("Internal Nodes")
@export var sprite: Sprite2D
@export var movement_cmp: MovementComponent
@export var anim_player: AnimationPlayer
@export var hitbox: Hitbox

var input_vector: Vector2 = Vector2.RIGHT
var accelerating: bool = true

var grenade_launch_speed: float = 0

func _ready() -> void:
    match (projectile_type):
        ProjectileType.MISSILE:
            # Rocket fuel lasts a limited amount of time
            var timer = get_tree().create_timer(missile_rocket_time)
            timer.timeout.connect(start_decelerating)

        ProjectileType.GRENADE:
            # Grenade is lobbed at speed
            velocity = movement_cmp.max_speed * input_vector
            grenade_launch_speed = velocity.length() # Z velocity
            accelerating = false

func _physics_process(_delta: float) -> void:
    if accelerating:
        movement_cmp.accelerate(self, input_vector)
    else:
        movement_cmp.decelerate(self)

    match (projectile_type):
        ProjectileType.MISSILE:
            if (velocity.length() < missile_explode_thresh \
                and anim_player.current_animation != "explode" \
                and not accelerating) or hitbox.hit_something:
                explode()
        
        ProjectileType.GRENADE:
            if anim_player.current_animation != "explode":
                update_grenade_height()
                if (velocity.length() < grenade_explode_thresh) or hitbox.hit_something:
                    explode()

    move_and_slide()

func update_grenade_height() -> void:
    var lob_sign = 1 if 0 <= rotation_degrees and rotation_degrees <= 90 \
                        or -90 <= rotation_degrees and rotation_degrees < 0 else -1
    var progress := log(maxf(velocity.length(), 0.001) / grenade_launch_speed) \
                    / log(grenade_explode_thresh / grenade_launch_speed)
    progress = clampf(progress, 0.0, 1.0)
    sprite.position.y -= lob_sign * grenade_peak * (1 - 2 * progress)
    sprite.rotation = - (1.0 - 2.0 * progress) * grenade_tilt * cos(rotation)

func explode() -> void:
    rotation = 0 # Explode animation should always be not rotated
    velocity = Vector2.ZERO # Should not be moving while exploding
    sprite.position.y = 0 # Should not be offset while exploding
    sprite.rotation = 0
    anim_player.play("explode")
    await anim_player.animation_finished
    queue_free()

func start_decelerating() -> void:
    accelerating = false
