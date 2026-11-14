extends CharacterBody2D
class_name ProjectileComponent

@export_group("Settings")
@export var time_to_deceleration: float = 0.5 ## How long until deceleration kicks in
@export var decceleration: float = 0.05
@export var explode_speed_thresh: float = 1 ## How low speed has to be to explode

@export_group("Internal Nodes")
@export var movement_cmp: MovementComponent
@export var anim_player: AnimationPlayer

var input_vector: Vector2 = Vector2.RIGHT

func _ready() -> void:
    var timer = get_tree().create_timer(time_to_deceleration)
    timer.timeout.connect(start_decelerating)

func _physics_process(_delta: float) -> void:
    movement_cmp.handle_movement(self, input_vector)

    # if velocity.length() < explode_speed_thresh:
    move_and_slide()

func explode() -> void:
    anim_player.play("explode")

func start_decelerating() -> void:
    movement_cmp.acceleration = decceleration
    input_vector = Vector2.ZERO