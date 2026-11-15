extends Node2D
class_name World

@export_group("Internal Nodes")
@export var player: Player
@export var pumpkin: Pumpkin

@export_group("Resources")
@export var lose_screen: PackedScene

func _ready() -> void:
    pumpkin.pumpkin_gone.connect(loss)

func loss() -> void:
    add_child(lose_screen.instantiate())