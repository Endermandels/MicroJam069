extends Node2D
class_name Pumpkin

@export_group("Internal Nodes")
@export var hurtbox: Hurtbox
@export var anim_player: AnimationPlayer
@export var stats: Stats
@export var sprite: Sprite2D

signal pumpkin_gone

var disabled: bool = false

func _physics_process(_delta: float) -> void:
    if hurtbox.stored_hitbox != null and not anim_player.is_playing() and not disabled:
        take_hit()
        if stats.hp > 0:
            start_invincibility()
        else:
            pumpkin_gone.emit()
            queue_free()

func take_hit() -> void:
    stats.hp -= hurtbox.stored_hitbox.stats.dmg
    var hp_ratio: float = float(stats.hp) / stats.max_hp
    sprite.frame = clampi(sprite.hframes - ceili(sprite.hframes * hp_ratio), 0, sprite.hframes - 1)
    Hud.update_pumpkin_health_bar(stats.hp, stats.max_hp)
    hurtbox.stored_hitbox = null

func start_invincibility() -> void:
    anim_player.play("invincible")
    hurtbox.monitoring = false
    await anim_player.animation_finished
    hurtbox.monitoring = true

func stop() -> void:
    disabled = true
