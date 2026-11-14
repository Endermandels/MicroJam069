extends Node
class_name Spawner

@export_group("External Nodes")
@export var player: Player
@export var spawn_node: Node
@export var spawn_points_parent: Node

@export_group("Resources")
@export var spawnables: Array[PackedScene]

func _ready() -> void:
	var spawn: Creature = spawnables.pick_random().instantiate()
	if spawn.ai_cmp.global_player_ref:
		spawn.ai_cmp.player_ref = player
	spawn.global_position = spawn_points_parent.get_children().pick_random().global_position
	spawn_node.add_child(spawn)
