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
    if gun_inp_cmp.shoot:
        animation_cmp.shoot()
        if gun_inp_cmp.shoot_vector != Vector2.ZERO:
            gun_cmp.shoot(gun_inp_cmp.shoot_vector, projectile_spawn)
            gun_inp_cmp.shoot = false
            gun_inp_cmp.shoot_vector = Vector2.ZERO

    if not animation_cmp.current_animation == "shoot":
        movement_cmp.accelerate(self, move_inp_cmp.move_vector)
    else:
        movement_cmp.decelerate(self)

    move_and_slide()
