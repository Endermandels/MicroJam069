extends AudioStreamPlayer2D
class_name RepetitiveSFX

@export_group("Settings")
@export var pitch_variance: float = 0.05

@onready var og_pitch: float = pitch_scale

func _ready() -> void:
    if autoplay:
        vary_pitch()

## Called externally
func vary_pitch() -> void:
    var min_pitch: float = max(og_pitch - pitch_variance / 2, 0)
    var max_pitch: float = max(og_pitch + pitch_variance / 2, 0)
    pitch_scale = randf_range(min_pitch, max_pitch)
