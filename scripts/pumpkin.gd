extends Sprite2D
class_name Pumpkin

@export_group("Internal Nodes")
@export var hurtbox: Hurtbox
@export var anim_player: AnimationPlayer
@export var stats: Stats

func _physics_process(_delta: float) -> void:
	if hurtbox.stored_hitbox != null and not anim_player.is_playing():
		anim_player.play("invincible")
		stats.hp -= hurtbox.stored_hitbox.stats.dmg
		Hud.update_pumpkin_health_bar(stats.hp, stats.max_hp)
		hurtbox.stored_hitbox = null
		hurtbox.monitoring = false
		await anim_player.animation_finished
		hurtbox.monitoring = true
