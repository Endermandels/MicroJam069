extends AnimationPlayer
class_name AnimationComponent

@export_group("External Nodes")
@export var sprite: Sprite2D

var anim_lock: bool = false
var disabled: bool = false

func handle_facing_direction(body: CharacterBody2D) -> void:
	if (current_animation == "idle" or current_animation == "run" or not is_playing()) and not disabled:
		var ang: float = rad_to_deg(body.velocity.angle())
		
		if body.velocity.length() > 10 and current_animation != "run":
			# start moving
			play("run")
		elif body.velocity.length() < 10 and current_animation != "idle":
			# stop moving
			play("idle")

		if abs(ang) <= 85:
			# right
			sprite.flip_h = false
		elif abs(ang) >= 95:
			# left
			sprite.flip_h = true

func shoot() -> void:
	custom_animation("shoot")

func cough() -> void:
	custom_animation("cough")

func faint() -> void:
	custom_animation("faint")

func custom_animation(anim_name: String):
	if current_animation != anim_name and not disabled:
		play(anim_name)
