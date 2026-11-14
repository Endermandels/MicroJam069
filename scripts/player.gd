extends CharacterBody2D
class_name Player

@export_group("External Nodes")
@export var projectile_spawn: Node

@export_group("Internal Nodes")
@export var move_inp_cmp: MoveInputComponent
@export var gun_inp_cmp: GunInputComponent
@export var movement_cmp: MovementComponent
@export var animation_cmp: AnimationComponent
@export var gun_cmp: GunComponent

func _process(_delta: float) -> void:
    animation_cmp.handle_facing_direction(self)

func _physics_process(_delta: float) -> void:
    var move_vector_override: Vector2 = move_inp_cmp.move_vector
    
    if gun_inp_cmp.shoot:
        animation_cmp.shoot()
        if gun_inp_cmp.shoot_vector != Vector2.ZERO:
            gun_cmp.shoot(gun_inp_cmp.shoot_vector, projectile_spawn)
            gun_inp_cmp.shoot = false
            gun_inp_cmp.shoot_vector = Vector2.ZERO

    if animation_cmp.current_animation == "shoot":
        move_vector_override = Vector2.ZERO

    movement_cmp.handle_movement(self, move_vector_override)

    move_and_slide()
