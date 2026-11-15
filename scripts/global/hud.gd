extends CanvasLayer
# Global

@export_group("Internal Nodes")
@export var pumpkin_health_bar: ProgressBar

func update_pumpkin_health_bar(remaining_hp: int, max_hp: int) -> void:
	pumpkin_health_bar.max_value = max_hp
	pumpkin_health_bar.value = remaining_hp
