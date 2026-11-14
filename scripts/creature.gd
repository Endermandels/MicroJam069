extends CharacterBody2D
class_name Creature

@export_group("Internal Nodes")
@export var ai_cmp: AIComponent
@export var movement_cmp: MovementComponent
@export var animation_cmp: AnimationComponent
@export var spray_hurtbox: Hurtbox
@export var stink_hurtbox: Hurtbox
@export var death_hurtbox: Hurtbox

func _process(_delta: float) -> void:
	animation_cmp.handle_facing_direction(self)

func _physics_process(_delta: float) -> void:
	if death_hurtbox.stored_hitbox != null:
		queue_free()

	ai_cmp.handle_spray_hurtbox(spray_hurtbox)
	ai_cmp.handle_stink_hurtbox(stink_hurtbox)
	movement_cmp.accelerate(self, ai_cmp.move_vector)
	
	move_and_slide()
