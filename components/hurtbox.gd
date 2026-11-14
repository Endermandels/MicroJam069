extends Area2D
class_name Hurtbox

var stored_hitbox: Hitbox = null

func _physics_process(_delta: float) -> void:
	for hitbox in get_overlapping_areas():
		if hitbox is Hitbox:
			stored_hitbox = hitbox
			stored_hitbox.hit_something = true
