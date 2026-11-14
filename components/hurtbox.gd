extends Area2D
class_name Hurtbox

var stored_hitbox: Hitbox = null

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox is Hitbox:
		stored_hitbox = hitbox
		hitbox.hit_something = true