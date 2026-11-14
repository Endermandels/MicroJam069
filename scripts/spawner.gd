extends Node
class_name Spawner

@export_group("Settings")
@export var spawn_interval: float = 6.0 ## Average time in seconds between spawns
@export var spawn_interval_variance: float = 2.0 ## How much to randomize the spawn interval

@export_group("External Nodes")
@export var player: Player
@export var spawn_node: Node
@export var spawn_points_parent: Node

@export_group("Resources")
@export var spawnables: Array[PackedScene]

func _ready() -> void:
	start_spawn_timer()

func start_spawn_timer() -> void:
	var min_interval = max(spawn_interval - spawn_interval_variance / 2, 0)
	var max_interval = max(spawn_interval + spawn_interval_variance / 2, 0)
	var timer := get_tree().create_timer(randf_range(min_interval, max_interval))
	timer.timeout.connect(spawn)

func spawn() -> void:
	var spawned: Creature = spawnables.pick_random().instantiate()
	if spawned.ai_cmp.global_player_ref:
		spawned.ai_cmp.player_ref = player
	spawned.global_position = spawn_points_parent.get_children().pick_random().global_position
	spawn_node.add_child(spawned)
	start_spawn_timer()
