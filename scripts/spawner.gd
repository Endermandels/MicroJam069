extends Node
class_name Spawner

@export_group("Settings")
@export var spawn_interval: float = 6.0 ## Average time in seconds between spawns
@export var spawn_interval_variance: float = 2.0 ## How much to randomize the spawn interval
@export var time_to_increase_spawn_rate: float = 10
@export var increase_spawn_rate_amount: float = 0.5
@export var increase_spawn_rate_variance: float = 0.5

@export_group("External Nodes")
@export var player: Player
@export var spawn_node: Node
@export var spawn_points_parent: Node

@export_group("Resources")
@export var spawnables: Array[PackedScene]

var disabled: bool = false

func _ready() -> void:
    start_spawn_timer()
    start_increase_rate_timer()

func start_spawn_timer() -> void:
    var min_interval = max(spawn_interval - spawn_interval_variance / 2, 0)
    var max_interval = max(spawn_interval + spawn_interval_variance / 2, 0)
    var timer := get_tree().create_timer(randf_range(min_interval, max_interval))
    timer.timeout.connect(spawn)

func start_increase_rate_timer() -> void:
    var timer := get_tree().create_timer(time_to_increase_spawn_rate)
    timer.timeout.connect(increase_spawn_rate)

func spawn() -> void:
    if not disabled:
        var spawned: Creature = spawnables.pick_random().instantiate()
        if spawned.ai_cmp.global_player_ref:
            spawned.ai_cmp.player_ref = player
        spawned.global_position = spawn_points_parent.get_children().pick_random().global_position
        spawn_node.add_child(spawned)
        start_spawn_timer()

func increase_spawn_rate() -> void:
    if not disabled:
        var min_rate_increase = max(increase_spawn_rate_amount - increase_spawn_rate_variance / 2, 0)
        var max_rate_increase = max(increase_spawn_rate_amount + increase_spawn_rate_variance / 2, 0)
        spawn_interval -= randf_range(min_rate_increase, max_rate_increase)
        start_increase_rate_timer()

func stop() -> void:
    disabled = true
