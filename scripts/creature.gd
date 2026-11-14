extends CharacterBody2D
class_name Creature

@export_group("Internal Nodes")
@export var ai_cmp: AIComponent
@export var movement_cmp: MovementComponent
@export var animation_cmp: AnimationComponent
@export var hurtbox: Hurtbox

func _process(_delta: float) -> void:
	animation_cmp.handle_facing_direction(self)

func _physics_process(_delta: float) -> void:
	ai_cmp.handle_hurtbox(hurtbox)
	movement_cmp.accelerate(self, ai_cmp.move_vector)
	
	move_and_slide()
