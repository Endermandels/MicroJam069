extends Node
class_name MoveInputComponent

''' Specifically, take input from the keyboard, mouse, etc. '''

var move_vector: Vector2 = Vector2.ZERO ## Normalized input vector for moving

func _process(_delta: float) -> void:
	var h_dir: float = Input.get_axis("move_left", "move_right")
	var v_dir: float = Input.get_axis("move_up", "move_down")

	move_vector = Vector2(h_dir, v_dir).normalized()
