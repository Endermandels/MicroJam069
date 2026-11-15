extends CanvasLayer
# Global

@export_group("Internal Nodes")
@export var pumpkin_health_bar: ProgressBar
@export var time_left_label: Label

func update_pumpkin_health_bar(remaining_hp: int, max_hp: int) -> void:
    pumpkin_health_bar.max_value = max_hp
    pumpkin_health_bar.value = remaining_hp

func update_time_left_label(time_left: float) -> void:
    time_left_label.text = "Time Left: %.1f" % time_left
