extends Node2D
class_name World

@export_group("Internal Nodes")
@export var player: Player
@export var pumpkin: Pumpkin
@export var win_timer: Timer
@export var spawner: Spawner

@export_group("Resources")
@export var lose_screen: PackedScene
@export var win_screen: PackedScene

var won: bool = false
var lost: bool = false

func _ready() -> void:
    pumpkin.pumpkin_gone.connect(loss)
    win_timer.timeout.connect(win)

func _process(_delta: float) -> void:
    Hud.update_time_left_label(win_timer.time_left)

func loss() -> void:
    if not won:
        add_child(lose_screen.instantiate())
        lost = true
        player.stop()

func win() -> void:
    if not lost:
        add_child(win_screen.instantiate())
        won = true
        spawner.stop()
        pumpkin.stop()
