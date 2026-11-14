extends Area2D
class_name Hurtbox

var stored_hitbox: Hitbox = null

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: Hitbox) -> void:
	stored_hitbox = hitbox
	hitbox.hit_something = true