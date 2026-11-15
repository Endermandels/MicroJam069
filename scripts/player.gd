extends CharacterBody2D
class_name Player

@export_group("External Nodes")
@export var projectile_spawn: Node

@export_group("Internal Nodes")
@export var move_inp_cmp: MoveInputComponent
@export var gun_inp_cmp: GunInputComponent
@export var movement_cmp: MovementComponent
@export var animation_cmp: AnimationComponent
@export var possessed_anim_player: AnimationPlayer
@export var hurt_anim_player: AnimationPlayer
@export var gun_cmp: GunComponent
@export var ghost_hurtbox: Hurtbox
@export var attack_hurtbox: Hurtbox
@export var possessed_timer: Timer
@export var stats: Stats
@export var health_bar: ProgressBar

signal player_dead

var disabled: bool = false

func _ready() -> void:
    possessed_timer.timeout.connect(possessed_anim_player.play.bind("RESET"))
    health_bar.max_value = stats.max_hp

func _process(_delta: float) -> void:
    if not disabled:
        animation_cmp.handle_facing_direction(self)

func _physics_process(_delta: float) -> void:
    if ghost_hurtbox.stored_hitbox != null and possessed_timer.is_stopped() and not disabled:
        possessed_timer.start()
        animation_cmp.custom_animation("possessed")
        possessed_anim_player.play("possessed")
    
    if attack_hurtbox.stored_hitbox != null:
        var dmg = attack_hurtbox.stored_hitbox.stats.dmg
        attack_hurtbox.stored_hitbox = null
        if hurt_anim_player.current_animation != "hurt" and stats.hp > 0:
            stats.hp -= dmg
            health_bar.value = stats.hp
            if stats.hp > 0:
                animation_cmp.custom_animation("hurt")
                hurt_anim_player.play("hurt")
            else:
                animation_cmp.custom_animation("exhausted")
                await animation_cmp.animation_finished
                player_dead.emit()

    if not possessed_timer.is_stopped() and possessed_timer.time_left < 3:
        possessed_anim_player.play("possessed_fast")
    
    if gun_inp_cmp.shoot and not disabled and stats.hp > 0:
        animation_cmp.shoot()
        if gun_inp_cmp.shoot_vector != Vector2.ZERO:
            gun_cmp.shoot(gun_inp_cmp.shoot_vector, projectile_spawn)
            gun_inp_cmp.shoot = false
            gun_inp_cmp.shoot_vector = Vector2.ZERO

    if animation_cmp.current_animation == "shoot" or disabled or stats.hp == 0:
        movement_cmp.decelerate(self)
    elif not possessed_timer.is_stopped():
        movement_cmp.accelerate(self, move_inp_cmp.move_vector.rotated(deg_to_rad(180)))
    else:
        movement_cmp.accelerate(self, move_inp_cmp.move_vector)

    move_and_slide()

func stop() -> void:
    disabled = true
    animation_cmp.custom_animation("exhausted")
