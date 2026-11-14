extends Node2D
class_name StinkAOE

@export_group("Settings")
@export var sustain_time: float = 3.0 ## Time sustaining AOE
@export var sustain_time_variance: float = 2.0 ## Random variation
@export var fade_time: float = 1.0 ## Time to fade AOE

func _ready() -> void:
    var min_sustain = max(sustain_time - sustain_time_variance / 2, 0)
    var max_sustain = max(sustain_time + sustain_time_variance / 2, 0)
    var timer = get_tree().create_timer(randf_range(min_sustain, max_sustain))
    timer.timeout.connect(fade)

func fade() -> void:
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate:a", 0, fade_time) # Fade out
    tween.tween_callback(queue_free) # Delete after fade