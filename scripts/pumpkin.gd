extends Sprite2D
class_name Pumpkin

@export_group("Internal Nodes")
@export var hurtbox: Hurtbox
@export var anim_player: AnimationPlayer
@export var stats: Stats

func _physics_process(_delta: float) -> void:
    if hurtbox.stored_hitbox != null and not anim_player.is_playing():
        take_hit()
        start_invincibility()

func take_hit() -> void:
    stats.hp -= hurtbox.stored_hitbox.stats.dmg
    var hp_ratio: float = float(stats.hp) / stats.max_hp
    frame = clampi(hframes - ceili(hframes * hp_ratio), 0, hframes - 1)
    Hud.update_pumpkin_health_bar(stats.hp, stats.max_hp)
    hurtbox.stored_hitbox = null

func start_invincibility() -> void:
    anim_player.play("invincible")
    hurtbox.monitoring = false
    await anim_player.animation_finished
    hurtbox.monitoring = true
